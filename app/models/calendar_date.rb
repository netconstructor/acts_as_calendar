class CalendarDate < ActiveRecord::Base
  belongs_to :calendar

  # discrete event occurrences
  has_and_belongs_to_many(:occurrences,
    {:class_name=>'CalendarEvent', :join_table=>'calendar_occurrences'})

  # actual events, including occurrences and recurrences
  # FIXME - can't flag this collection readonly, maybe it could be disabled
  # by overriding create, <<, et. al.?
  has_and_belongs_to_many(:events,
    {:class_name=>'CalendarEvent', :join_table=>'calendar_event_dates'})

  validates_presence_of :calendar
  validates_presence_of :value
  validates_presence_of :weekday
  validates_presence_of :monthweek
  validates_presence_of :monthday

  before_validation_on_create :derive_date_parts

  private

  def derive_date_parts
    self.weekday = value.wday
    self.monthday = value.mday
    self.monthweek = monthday / 7
  end
end
