class Authentication < ActiveType::Object

  after_validation :retrive_user

  attribute :username, :string
  attribute :password, :string

  validates :username, presence: true
  validates :password, presence: true

  def retrive_user
    @user = User.find_by(username: self.username, password: self.password)
  end

  def token
    @user.token
  end

end