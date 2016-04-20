class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:confirmation ]

  # GET /subscriptions/new
  def new
    @subscription = Subscription.new
  end
  
  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @subscription = Subscription.new(subscription_params)

    respond_to do |format|
      if @subscription.save
        format.html { redirect_to root_path, notice: 'Please check your email to confirm your subscription' }
        format.json { render :show, status: :created, location: @subscription }
      else
        format.html { render :new }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /subscriptions/1&token=
  def confirmation
    flash.notice = if @subscription.confirmed?(params[:token])
      "Subscription confirmed"
    else
      "Subscription NOT confirmed - try again please."
    end

    redirect_to root_url
  end
  
  # GET /unsubscribe/:token
  def unsubscribe
    flash.notice = if Subscription.unsubscribe(params[:token])
      "Subscription cancelled"
    else
      "Subscription NOT cancelled - try again please."
    end

    redirect_to root_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      params.require(:subscription).permit(:email)
    end
end
