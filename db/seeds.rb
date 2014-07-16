# encoding: UTF-8
# 内置数据

# 用户角色
        saler = Role.create(name: 'saler',         label: '销售员',   description: "普通销售人员")
  sale_leader = Role.create(name: 'sale_leader',   label: '销售组长', description: "销售小组长")
sale_director = Role.create(name: 'sale_director', label: '销售总监', description: "销售总监")
    developer = Role.create(name: 'developer',     label: '开发人员', description: "开发人员")
          cto = Role.create(name: 'cto',           label: '技术总监', description: "技术总监")
         root = Role.create(name: 'root',          label: 'root',    description: "最高权限")

# 菜单
root_menu = Menu.create(name: 'root', label: 'root', parent_id: nil)

home = Menu.create( name: 'home',
                    label: '首页',
                    link_url: '/home',
                    parent_id: root_menu.id)

profile = Menu.create( name: 'profile',
                       label: '个人信息',
                       link_url: '/users/profile',
                       parent_id: root_menu.id )
Menu.create( name: 'profile_update',
             label: '信息修改',
             link_url: '/users/profile',
             parent_id: profile.id )
Menu.create( name: 'password_update',
             label: '密码修改',
             link_url: '/users/pwd_reset',
             parent_id: profile.id )

customer = Menu.create( name: 'customer',
                        label: '客户管理',
                        link_url: '/customers',
                        parent_id: root_menu.id)
Menu.create( name: 'customer_list',
             label: '客户列表',
             link_url: '/customers',
             parent_id: customer.id )

# 角色对应的菜单

default_menus = [ home, profile, customer ]
saler.menus = default_menus
saler.save

sale_leader.menus = default_menus
sale_leader.save

sale_director.menus = default_menus
sale_director.save

developer.menus = default_menus
developer.save

cto.menus = default_menus
cto.save

root.menus = default_menus
root.save