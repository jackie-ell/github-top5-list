class UsersController < ApplicationController
  def index
  end

  def show
    @user = params[:user]

    uri = URI("https://api.github.com/users/%s/repos" % [@user])

    @user_repos = APICache.get(@user) do
      res = Net::HTTP.get_response(uri)

      case res
      when Net::HTTPOK, Net::HTTPSuccess then
        res.body
      when Net::HTTPNotFound then
        Net::HTTPNotFound
      when Net::HTTPUnauthorized then
        Net::HTTPUnauthorized
      when APICache::TimeoutError then
        APICache::TimeoutError
      else
        res
      end
    end

    if @user_repos == Net::HTTPNotFound then
      @error = "User not found."
    elsif @user_repos == Net::HTTPUnauthorized then
      @error = "GitHub rate limit reached. Try again later."
    elsif @user_repos == APICache::TimeoutError
      @error = "Connection timed out."
    end

  end
end
