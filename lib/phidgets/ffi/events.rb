module Phidgets
  module FFI
    module Events
      class EventManager
        attr_reader :name

        def initialize(name, &block)
          @name, @wrapper = name, block
          @blocks, @anonymous_blocks = {}, []
        end

        def call(handle, object, *extra)
          wrapped(*extra) { |*args| run_blocks(*args) }
          nil
        rescue Exception
          nil
        end

        def clear
          [@blocks.clear, @anonymous_blocks.clear]
        end

        def inspect
          "#<#{self.class} name: #{name}>"
        end

        def register(name = nil, &block)
          if name
            @blocks[name] = block
          else
            @anonymous_blocks << block
            block
          end
        end

        def set(&block)
          clear
          register(&block)
        end

        def unregister(name)
          @blocks.delete(name)
        end

        def unset
          clear
        end

        protected
          def run_blocks(*args)
            @blocks.each do |name, block|
              begin
                block.call(*args)
              rescue
                @blocks.delete(name)
                # report this?
              end
            end
            @anonymous_blocks.each do |block|
              begin
                block.call(*args)
              rescue
                @anonymous_blocks.delete(block)
                # report this?
              end
            end
          end

          def wrapped(*extra)
            if @wrapper
              @wrapper.call(*extra) { |*args| run_blocks(*args) }
            else
              run_blocks(*extra)
            end
          end
      end

      def self.included(base)
        base.class_exec do
          extend ClassMethods
          self.events = []
        end
      end

      private
        def initialize_events
          @events = {}
          self.class.events.each do |event|
            name, method, block = event.values_at(:name, :method, :block)
            manager = EventManager.new(name, &block)
            check_result(send(method, handle, manager, nil))
            @events[name] = manager
          end
          nil
        end

      module ClassMethods
        def events
          @@events
        end

        private
          def events=(value)
            @@events = value.freeze
          end

          def event(name, method, &block)
            self.events = events + [{ name: name, method: method, block: block }]
            class_eval <<-RUBY, __FILE__, __LINE__ + 1
              def #{name}
                if block_given?
                  events[:#{name}].set(&block)
                else
                  events[:#{name}]
                end
              end
            RUBY
            nil
          end
      end
    end
  end
end
