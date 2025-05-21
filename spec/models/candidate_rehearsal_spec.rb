require 'rails_helper'

RSpec.describe CandidateRehearsal, type: :model do
  subject { build(:candidate_rehearsal) }

  describe "validations" do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_uniqueness_of(:candidat_id).scoped_to(:tour_id).with_message("already has a rehearsal for this tour") }
  end

  describe "associations" do
    it { should belong_to(:room) }
    it { should belong_to(:tour) }
    it { should belong_to(:candidat) }
    it { should belong_to(:pianist_accompagnateur).optional }
    it { should belong_to(:performance).optional }
  end

  describe "scopes" do
    let(:room) { create(:room) }
    let(:date) { Date.current }
    let!(:rehearsal1) { create(:candidate_rehearsal, room: room, start_time: date.noon, end_time: date.noon + 30.minutes) }
    let!(:rehearsal2) { create(:candidate_rehearsal, room: room, start_time: date.noon + 1.hour, end_time: date.noon + 1.5.hours) }
    let!(:different_room_rehearsal) { create(:candidate_rehearsal, start_time: date.noon, end_time: date.noon + 30.minutes) }
    let!(:different_date_rehearsal) { create(:candidate_rehearsal, room: room, start_time: (date + 1.day).noon, end_time: (date + 1.day).noon + 30.minutes) }

    describe ".for_room" do
      it "returns rehearsals for the specified room" do
        expect(CandidateRehearsal.for_room(room).count).to eq 3
        expect(CandidateRehearsal.for_room(room)).not_to include(different_room_rehearsal)
      end
    end

    describe ".for_day" do
      it "returns rehearsals for the specified day" do
        expect(CandidateRehearsal.for_day(date).count).to eq 3
        expect(CandidateRehearsal.for_day(date)).not_to include(different_date_rehearsal)
      end
    end

    describe ".overlapping" do
      it "returns rehearsals overlapping with the specified time range" do
        overlapping = CandidateRehearsal.overlapping(date.noon + 15.minutes, date.noon + 45.minutes)
        expect(overlapping).to include(rehearsal1)
        expect(overlapping).not_to include(rehearsal2)
        expect(overlapping).to include(different_room_rehearsal)
        expect(overlapping).not_to include(different_date_rehearsal)
      end
    end
  end

  describe "#end_time_after_start_time" do
    it "is valid when end_time is after start_time" do
      rehearsal = build(:candidate_rehearsal, start_time: Time.current, end_time: Time.current + 1.hour)
      expect(rehearsal).to be_valid
    end

    it "is invalid when end_time is before start_time" do
      rehearsal = build(:candidate_rehearsal, start_time: Time.current, end_time: Time.current - 1.hour)
      expect(rehearsal).not_to be_valid
      expect(rehearsal.errors[:end_time]).to include("must be after start time")
    end

    it "is invalid when end_time is equal to start_time" do
      time = Time.current
      rehearsal = build(:candidate_rehearsal, start_time: time, end_time: time)
      expect(rehearsal).not_to be_valid
      expect(rehearsal.errors[:end_time]).to include("must be after start time")
    end
  end

  describe "#no_overlapping_time_for_room" do
    let(:room) { create(:room) }
    let(:start_time) { Time.current.change(hour: 10) }
    let(:end_time) { start_time + 30.minutes }
    let!(:existing_rehearsal) { create(:candidate_rehearsal, room: room, start_time: start_time, end_time: end_time) }

    context "when creating a new rehearsal with overlapping time in the same room" do
      it "is invalid with exactly the same time" do
        rehearsal = build(:candidate_rehearsal, room: room, start_time: start_time, end_time: end_time)
        expect(rehearsal).not_to be_valid
        expect(rehearsal.errors[:base]).to include("This time slot overlaps with another rehearsal in the same room")
      end

      it "is invalid when starting during another rehearsal" do
        rehearsal = build(:candidate_rehearsal, room: room, start_time: start_time + 15.minutes, end_time: end_time + 15.minutes)
        expect(rehearsal).not_to be_valid
        expect(rehearsal.errors[:base]).to include("This time slot overlaps with another rehearsal in the same room")
      end

      it "is invalid when ending during another rehearsal" do
        rehearsal = build(:candidate_rehearsal, room: room, start_time: start_time - 15.minutes, end_time: end_time - 15.minutes)
        expect(rehearsal).not_to be_valid
        expect(rehearsal.errors[:base]).to include("This time slot overlaps with another rehearsal in the same room")
      end

      it "is invalid when encompassing another rehearsal" do
        rehearsal = build(:candidate_rehearsal, room: room, start_time: start_time - 15.minutes, end_time: end_time + 15.minutes)
        expect(rehearsal).not_to be_valid
        expect(rehearsal.errors[:base]).to include("This time slot overlaps with another rehearsal in the same room")
      end
    end

    context "when creating a non-overlapping rehearsal in the same room" do
      it "is valid" do
        rehearsal = build(:candidate_rehearsal, room: room, start_time: end_time + 1.minute, end_time: end_time + 31.minutes)
        expect(rehearsal).to be_valid
      end
    end

    context "when creating an overlapping rehearsal in a different room" do
      it "is valid" do
        rehearsal = build(:candidate_rehearsal, start_time: start_time, end_time: end_time)
        expect(rehearsal).to be_valid
      end
    end
  end
end
