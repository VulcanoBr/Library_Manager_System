class University < ApplicationRecord

  has_many :libraries
  has_many :students
  has_one :address, dependent: :destroy
  has_many :telephones, dependent: :destroy
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :telephones, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :homepage, presence: true
  validates :homepage, uniqueness: { case_sensitive: false }
  validates :homepage, format: { with: /\Awww\..+\.com\z/,
                            message: "deve seguir o padrão www. e .com" }
  validates :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates_format_of :email, uniqueness: true, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

  scope :ordered_by_name, -> { order(:name) }

  def self.with_addressXXX_and_telephonesXXX
    left_joins(:address, :telephones)
      .select('universities.*,
               CASE WHEN addresses.id IS NULL THEN "N" ELSE "S" END AS has_address,
               CASE WHEN telephones.id IS NULL THEN "N" ELSE "S" END AS has_telephones')
      .group('universities.id')
  end

  def self.with_address_and_telephonesZZZZ
    select('universities.*,
             (CASE WHEN addresses.id IS NULL THEN "N" ELSE "S" END) AS has_address,
             (CASE WHEN telephones.id IS NULL THEN "N" ELSE "S" END) AS has_telephones')
      .left_joins(:address)
      .left_joins(:telephones)
      .group('universities.id')
  end

  def self.with_address_and_telephones
    select(
      'universities.*,
       CASE WHEN EXISTS (SELECT 1 FROM addresses WHERE addresses.university_id = universities.id) THEN \'S\' ELSE \'N\' END AS has_address,
       CASE WHEN EXISTS (SELECT 1 FROM telephones WHERE telephones.university_id = universities.id) THEN \'S\' ELSE \'N\' END AS has_telephones'
    )
  end

end
