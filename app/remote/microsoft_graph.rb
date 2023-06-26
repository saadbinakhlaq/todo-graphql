class MicrosoftGraph
  attr_reader :access_token
  include HTTParty
  logger ::Logger.new STDOUT
  class MicrosoftGraphError < StandardError; end

  BASE_URL = "https://graph.microsoft.com/v1.0/me/todo"

  def initialize(access_token)
    @access_token = access_token
  end


  def lists
    path = "/lists"
    response = self.class.get("#{BASE_URL}#{path}", headers: headers)
    if response["error"].present?
      raise MicrosoftGraphError, response["error"]["message"]
    else
      response
    end
  end

  def tasks(list_id)
    path = "/lists/#{list_id}/tasks"
    response = self.class.get("#{BASE_URL}#{path}", headers: headers)
    if response["error"].present?
      raise MicrosoftGraphError, response["error"]["message"]
    else
      response
    end
  end

  def all_tasks
    all_lists = lists
    tasks = []
    all_lists["value"].each do |list|
      response_tasks = self.tasks(list["id"])
      response_tasks["value"].each do |task|
        task["list"] = list
        tasks << task
      end
    end
    tasks
  end

  private

  def headers
    @__headers ||= {
      "Authorization" => "Bearer #{access_token}"
    }
  end
end