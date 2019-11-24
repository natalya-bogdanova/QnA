class GistService

  def initialize(gist, client = default_client)
    @gist_hash = gist.split('/').last
    @client = client
  end

  def call
    begin
      @responce = @client.gist(@gist_hash)
      files_content

    rescue Octokit::NotFound
      'Gist not found'
    end
  end

  def default_client
    Octokit::Client.new
  end

  private

  def files_content
    array = @responce&.files&.to_h.values.map { |file,_| "#{file[:filename].upcase}" + "\n" + file[:content] }
    array&.join("\n\n")
  end
end
