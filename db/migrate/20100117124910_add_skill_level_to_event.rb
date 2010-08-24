class AddSkillLevelToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :skill_level, :integer
  end

  def self.down
    remove_column :events, :skill_level
  end
end
