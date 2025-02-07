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

  after_save :create_speaker, if: -> { activity? }

  after_initialize :generate_unique_code, if: :new_record?
  after_update :create_announcement

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

  def create_announcement
    event = schedule.event
    user = event.user
    changes = saved_changes.except(:updated_at, :schedule_type)

    change_messages = changes.map do |attribute, values|
      next if values[0] == values[1]

      case attribute
      when "name"
        "Nome alterado de '#{values[0]}' para '#{values[1]}'"
      when "description"
        "Descrição alterada de '#{values[0]}' para '#{values[1]}'"
      when "start_time", "end_time"
        "#{attribute == 'start_time' ? 'Início' : 'Término'} alterado de '#{values[0].strftime('%H:%M')}' para '#{values[1].strftime('%H:%M')}'"
      when "responsible_name"
        "Responsável alterado de '#{values[0]}' para '#{values[1]}'"
      else
        nil
      end
    end.compact.join(", ")

    return if change_messages.blank?
    Announcement.create!(
      event: event,
      user: user,
      title: "Atualização na atividade #{name}",
      description: "As seguintes alterações foram feitas: #{change_messages}."
    )
  end
end
