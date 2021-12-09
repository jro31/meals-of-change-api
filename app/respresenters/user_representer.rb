class UserRepresenter
  def initialize(user, include_email = true)
    @user = user
    @include_email = include_email
  end

  def as_json
    {
      id: user.id,
      email: user.email,
      display_name: user.display_name
    }.except(@include_email ? nil : :email)
  end

  private

  attr_reader :user
end
