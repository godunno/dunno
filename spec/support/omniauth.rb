OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
  provider: 'facebook',
  uid: "12345678",
  info: {
    email: "darthvader@example.org",
    name: "Darth Vader",
    image: "http://graph.facebook.com/awesome_photo.png"
  },
  credentials: {
    token: "...",
    expires_at: 1_441_880_921,
    expires: true
  },
  extra: {
    raw_info: {
      name: "xxx",
      email: "xxxxxx@gmail.com",
      id: "xxxxxxxxxx"
    }
  }
)
