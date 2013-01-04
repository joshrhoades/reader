class FixShortFields < ActiveRecord::Migration
  def up
    change_column :entries, :guid, :string, :limit => 4096
    change_column :entries, :title, :string, :limit => 4096
    change_column :entries, :url, :string, :limit => 4096
    change_column :entries, :author, :string, :limit => 4096
    change_column :entries, :summary, :string, :limit => 4096

    change_column :entry_guids, :guid, :string, :limit => 4096

    change_column :facebook_contacts, :names, :text

    change_column :feed_icons, :uri, :string, :limit => 4096
    change_column :feed_icons, :feed_icon, :string, :limit => 4096

    change_column :feeds, :feed_url, :string, :limit => 4096
    change_column :feeds, :site_url, :string, :limit => 4096
  end

  def down
    change_column :entries, :guid, :string, :limit => 255
    change_column :entries, :title, :string, :limit => 255
    change_column :entries, :url, :string, :limit => 255
    change_column :entries, :author, :string, :limit => 255
    change_column :entries, :summary, :string, :limit => 255

    change_column :entry_guids, :guid, :string, :limit => 255

    change_column :facebook_contacts, :names, :string

    change_column :feed_icons, :uri, :string, :limit => 255
    change_column :feed_icons, :feed_icon, :string, :limit => 255

    change_column :feeds, :feed_url, :string, :limit => 255
    change_column :feeds, :site_url, :string, :limit => 255
  end
end
