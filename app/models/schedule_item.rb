class ScheduleItem < ApplicationRecord
  belongs_to :schedule

  enum :schedule_type, [ :activity, :interval ]

  validates :name, :start_time, :end_time, :schedule_type, presence: true
  validates :description, :responsible_name, :responsible_email, presence: true, if: -> { activity? }

  validate :end_time_must_be_greater_than_start_time
  validate :no_time_conflict_with_other_items

  after_create :create_speaker, if: -> { activity? }

  private


  def end_time_must_be_greater_than_start_time
    return unless start_time && end_time
    if end_time < start_time
      errors.add(:end_time, "deve ser depois do início")
    end
  end

  def no_time_conflict_with_other_items
    return unless start_time && end_time && schedule

    overlapping_items = schedule.schedule_items
                                .where.not(id: id)
                                .where("start_time < ? AND end_time > ?", end_time, start_time)

    if overlapping_items.exists?
      errors.add(:start_time, "não pode conflitar com horários de outros itens")
    end
  end

  def create_speaker
    Speaker.create!(name: self.responsible_name, email: self.responsible_email)
  end
end
