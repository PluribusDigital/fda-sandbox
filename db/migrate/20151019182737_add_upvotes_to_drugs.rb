class AddUpvotesToDrugs < ActiveRecord::Migration
  def change
    add_column :drugs, :upvotes, :integer, default:0
  end
end
