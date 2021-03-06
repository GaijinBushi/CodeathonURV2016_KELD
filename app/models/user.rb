class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :degree
  belongs_to :center
  has_many :user_subjects
  has_many :questions, :class_name => 'Question', :foreign_key => 'sender_id'
  has_many :reports, :class_name => 'Report', :foreign_key => 'sender_id'
  has_many :tests
  has_many :user_badges
  has_many :badges, through: :user_badges
  has_many :test_questions, through: :tests
  has_many :subjects, through: :user_subjects
  has_many :exams, through: :subjects

  before_create :set_default_values



  def set_default_values
    if self.new_record?
      self.level = 1
      self.experience = 0
    end
  end

  def name
    "#{first_name} #{last_name}"
  end
end
