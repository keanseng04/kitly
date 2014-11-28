require 'securerandom'

get '/' do
  # let user create new short URL, display a list of shortened URLs
  # @shortened_url = Url.where(url: "#{params[:long_url]}").last
  # @url = Url.all
  erb :index
end

post '/urls' do
  # create a new Url
  # @url = Url.create(url: params[:long_url], kitly: "http://kitly/" +"#{Url.shortener}")
  @url = Url.create(url: params[:long_url], count: 0)
  erb :create_url
end

# e.g., /q6bda
get '/:short_url' do
  # puts params
  # redirect to appropriate "long" URL
  url = Url.where(kitly: params[:short_url]).first
  url.count += 1
  url.save
  redirect to url.url

end
