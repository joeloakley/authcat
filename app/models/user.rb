class User < ActiveRecord::Base
  has_secure_password

  validates :email, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :password, length: { minimum: 5}


  def deliver_password_reset_instructions
    self.perishable_token = SecureRandom.hex(4)
    save(validate: false)

    PasswordResetNotifier.password_reset_instructions(self).deliver_now
  end


end
