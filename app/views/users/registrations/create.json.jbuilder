json.(@user, :id, :name, :email, :errors)
json.success @user.persisted?