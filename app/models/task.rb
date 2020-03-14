class Task < ApplicationRecord
    has_one_attached :image

    before_validation :set_nameless_name

    validates :name, presence: true, length: { maximum: 30 }

    belongs_to :user
    # belongs_to :tag
    
    scope :recent_created, -> { order(created_at: :desc) }
    scope :recent_updated, -> { order(updated_at: :desc) }

    def self.ransackable_attributes(auth_object = nil)
      %w[name deadline]
    end

    def self.ransackable_associations(auth_object = nil)
      []
    end

    private
    def set_nameless_name
      self.name = 'タスク名なし' if name.blank?
    end
end
