module UsersHelper
  def admin_name(admin)
    { User::ADMIN[:none] => t('admin.none'),
      User::ADMIN[:admin] => t('admin.admin'),
    }[admin]
  end
end
