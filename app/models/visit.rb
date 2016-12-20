class Visit < ApplicationRecord
  belongs_to :user

  def self.track_sign_in(user)
    visit = find_or_create_by(user: user, visited_at: Date.today)

    visit.delay(run_at: 30.days.from_now).delete
  end
end
