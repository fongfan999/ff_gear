module Commontator
  class SubscriptionsController < Commontator::ApplicationController
    before_filter :set_thread

    # PUT /threads/1/subscribe
    def subscribe
      security_transgression_unless @thread.can_subscribe?(@user)

      unless @thread.subscribe(@user)
        @thread.errors.add(:base,
          t('commontator.subscription.errors.already_subscribed'))
      end
        

      respond_to do |format|
        format.html { redirect_to @thread }
        format.js { render :subscribe }
      end

    end

    # PUT /threads/1/unsubscribe
    def unsubscribe
      security_transgression_unless @thread.can_subscribe?(@user)

      unless @thread.unsubscribe(@user)
        @thread.errors.add(:base,
          t('commontator.subscription.errors.not_subscribed'))
      end
        

      respond_to do |format|
        format.html { redirect_to @thread }
        format.js { render :subscribe }
      end
    end
  end
end
