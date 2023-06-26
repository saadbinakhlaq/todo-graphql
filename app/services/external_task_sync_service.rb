class ExternalTaskSyncService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def sync
    raise NotImplementedError
  end
end