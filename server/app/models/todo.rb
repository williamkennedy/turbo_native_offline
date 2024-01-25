class Todo < ApplicationRecord
  after_create_commit -> { broadcast_append_later_to :todos }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :todos }
end
