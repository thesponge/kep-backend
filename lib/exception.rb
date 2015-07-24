module Exceptions
  class PrioritableIconsistencyError < StandardError
    def initialize()
      @message = "All the priorities
      within a batch should belong to the same Assignment/Priority"
    end
  end
end
