class Task < ApplicationRecord
    before_validation :set_nameless_name

    validates :name, presence: true, length: { maximum: 30 }

    belongs_to :user
    
    private
    def set_nameless_name
        self.name = 'タスク名なし' if name.blank?
    end
end
