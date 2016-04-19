module CommentsHelper
  def avatar_url(email)
    default_url = "https://robohash.org/#{request.remote_ip}.png"

    gravatar_id = Digest::MD5::hexdigest(email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=75&d=#{CGI.escape(default_url)}"
  end
end
