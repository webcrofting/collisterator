#http://kellishaver.tumblr.com/post/40758797489/cors-headers-with-devise
#http://stackoverflow.com/questions/3428343/where-do-you-put-your-rack-middleware-files-and-requires

class Cors
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)

    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'DELETE, GET, HEAD, OPTIONS, POST, PUT'
    headers['Access-Control-Max-Age'] = '1728000'

    [status, headers, response]
  end
end
