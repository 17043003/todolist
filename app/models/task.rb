class Task < ApplicationRecord
    before_validation :set_nameless_name

    validates :name, presence: true, length: { maximum: 30 }

    belongs_to :user
    
    scope :recent_created, -> { order(created_at: :desc) }
    scope :recent_updated, -> { order(updated_at: :desc) }

    private
    def set_nameless_name
        self.name = 'タスク名なし' if name.blank?
    end
end
