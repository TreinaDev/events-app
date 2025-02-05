class ScheduleItem < ApplicationRecord
  include Discard::Model

  default_scope -> { kept }

  belongs_to :schedule
  belongs_to :speaker, foreign_key: "responsible_email", primary_key: "email", optional: true

  enum :schedule_type, [ :activity, :interval ]

  validates :name, :start_time, :end_time, :schedule_type, :code, presence: true
  validates :description, :responsible_name, :responsible_email, presence: true, if: -> { activity? }
  validates :code, uniqueness: true

  validate :end_time_must_be_greater_than_start_time
  validate :no_time_conflict_with_other_items

  after_create :create_speaker, if: -> { activity? }

  after_initialize :generate_unique_code, if: :new_record?

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
    speaker = Speaker.find_by(email: self.responsible_email)

    Speaker.create!(name: self.responsible_name, email: self.responsible_email) unless speaker.present?
  end

  def generate_unique_code
    self.code = loop do
      random_code = SecureRandom.alphanumeric(8).upcase
      break random_code unless Speaker.exists?(code: random_code)
    end
  end
end
