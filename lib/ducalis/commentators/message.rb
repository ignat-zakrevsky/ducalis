# frozen_string_literal: true

module Ducalis
  module Commentators
    class Message
      LINK_FORMAT = '[%<cop_name>s](<%<link>s>)'.freeze
      SITE = 'https://ducalis-rb.github.io'.freeze

      def initialize(offense)
        @message = offense.message
        @cop_name = offense.cop_name
      end

      def with_link
        if @message.include?(@cop_name)
          @message.sub(@cop_name, cop_with_link)
        else
          [cop_with_link, ': ', @message].join
        end
      end

      private

      def cop_with_link
        format(LINK_FORMAT, cop_name: @cop_name, link: cop_link)
      end

      def cop_link
        URI.join(SITE, anchor).to_s
      end

      def anchor
        "##{@cop_name.delete('/').downcase}"
      end
    end
  end
end
