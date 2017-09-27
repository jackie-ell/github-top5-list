class UsersController < ApplicationController
  def index
  end

  def show
    @user = params[:user]

    uri = URI("https://api.github.com/users/%s/repos" % [@user])
    # data = {'Accept'=>'application/vnd.github.v3+json'}

    @user_repos = APICache.get(@user) do
      res = Net::HTTP.get_response(uri)

      case res
      when Net::HTTPOK, Net::HTTPSuccess then
        res.body
      when Net::HTTPNotFound then
        @error = "User not found."
        Net::HTTPNotFound
      when Net::HTTPUnauthorized then
        @error = "GitHub rate limit reached. Try again later."
        Net::HTTPUnauthorized
      else
        @error = res.body
        res
      end
    end
  end
end
