class Account < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  # Validations
  validates_presence_of     :email, :role
  validates_presence_of     :password,                   :if => :password_required
  validates_presence_of     :password_confirmation,      :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_confirmation_of :password,                   :if => :password_required
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of       :role,     :with => /[A-Za-z]/

  # Callbacks
  before_save :encrypt_password, :if => :password_required

  # Access settings for default account here
  def self.default
    find_by!(email: 'admin@luethi-chleehof.ch')
  end

  ##
  # This method is for authentication purpose.
  #
  def self.authenticate(email, password)
    account = where("lower(email) = lower(?)", email).first if email.present?
    account && account.has_password?(password) ? account : nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  private

  def encrypt_password
    value = ::BCrypt::Password.create(password)
    value = value.force_encoding(Encoding::UTF_8) if value.encoding == Encoding::ASCII_8BIT
    self.crypted_password = value
  end

  def password_required
    crypted_password.blank? || password.present?
  end
end
