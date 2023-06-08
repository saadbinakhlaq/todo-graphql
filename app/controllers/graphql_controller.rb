class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      # current_user: current_user,
      current_user: current_user,
      decoded_token: decoded_token
    }
    result = AppSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  def current_user
    @current_user = nil
    if decoded_token
      data = decoded_token
      user = User.find(data[:user_id]) if data[:user_id].present?
      if data[:user_id].present? && !user.nil?
        @current_user ||= user
      end
    end
  end

  def decoded_token
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    if header
      begin
        @decoded_token ||= JsonWebToken.decode(header)
      rescue JWT::DecodeError => e
        raise GraphQL::ExecutionError.new(e.message)
      rescue StandardError => e
        raise GraphQL::ExecutionError.new(e.message)
      rescue e
        raise GraphQL::ExecutionError.new(e.message)
      end
    end
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end
