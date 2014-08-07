# encoding: UTF-8
# 内置数据

def import_city
  city = City.first
  if city.nil?
    json_cities = File.open('db/cities.json').read
    data = JSON.parse(json_cities)
    data.each do |data|
      province_id = data["id"]
      province_name = data["name"]
      cities = data["subs"]
      province = Province.new(name: province_name, province_id: province_id)
      province.save
      cities.each do |city|
        city_id = city["id"]
        city_name = city["name"]
        province.cities.create(name: city_name, city_id: city_id)
      end
    end
  end
end

def create_roles_and_menus
  root = Menu.create(name: 'root')
  customer = Menu.create( key: 'customer',
                          name: '客户管理',
                          url: '/customers/manage',
                          parent: root )
  new_customer  = Menu.create( key: 'new_customer',
                               name: '添加客户',
                               url: '/customers/new',
                               parent: customer )
  my_customers  = Menu.create( key: 'my_customers',
                               name: '我的客户',
                               url: '/profile/customers',
                               parent: customer )
  customer_list = Menu.create( key: 'index',
                               name: '区域客户列表',
                               url: '/customers',
                               parent: customer )

  info = Menu.create(key: 'info', name: '个人信息', url: '/profile', parent: root)
  profile = Menu.create( key: 'profile',
                         name: '个人主页',
                         url: '/profile',
                         parent: info )
  pwd_reset = Menu.create( key: 'pwd_reset',
                           name: '重置密码',
                           url: '/reset',
                           parent: info )

  admin = Role.new(name: 'root', label: '总监', permission: { detail: true })
  admin.menus = [ customer, new_customer, my_customers, customer_list,
                  info, profile, pwd_reset ]
  admin.save

  area = Role.new(name: 'area', label: '大区经理', permission: { detail: false })
  area.menus = [ customer, new_customer, my_customers, customer_list,
                 info, profile, pwd_reset ]
  area.save

  province = Role.new(name: 'province', label: '区域主管', permission: { detail: false })
  province.menus = [ customer, new_customer, my_customers, customer_list,
                     info, profile, pwd_reset ]
  province.save

  city = Role.new(name: 'city', label: '服务顾问', permission: { detail: false })
  city.menus = [ customer, new_customer, my_customers, info, profile, pwd_reset ]
  city.save

  trainee = Role.new(name: 'trainee', label: '管培生', permission: { detail: false })
  trainee.menus = [ customer, new_customer, my_customers, info, profile, pwd_reset ]
  trainee.save
end

def create_users
  User.create( login: 'root',
               mobile: '15968101221',
               active: true,
               role_id: 1,
               password: 'root@souche',
               password_confirmation: 'root@souche' )
end

def import_data
  import_city
  create_users
  create_roles_and_menus
end

import_data


=begin

provinces = [ '河北', '山西', '内蒙古自治区', '辽宁', '吉林', '黑龙江', '江苏', '浙江',
              '安徽', '福建', '江西', '山东', '河南', '湖北', '湖南', '广东', '广西壮族自治区',
              '海南', '四川', '贵州', '云南', '西藏自治区', '陕西', '甘肃', '青海',
              '宁夏回族自治区', '新疆维吾尔自治区'
            ]

Province.create(name: '北京')
Province.create(name: '天津')
Province.create(name: '上海')
Province.create(name: '重庆')

hebei = Province.new(name: '河北')
hebei.save
names = [ '石家庄', '唐山', '秦皇岛', '邯郸', '邢台', '保定', '张家口', '承德', '沧州', '廊坊', '衡水' ]
names.each do |name|
  hebei.cities.create(name: name)
end

shanxi = Province.new(name: '山西')
shanxi.save
names = [ '太原', '大同', '阳泉', '长治', '晋城', '朔州', '晋中', '运城', '忻州', '临汾', '吕梁' ] 
names.each do |name|
  shanxi.cities.create(name: name)
end

neimeng = Province.new(name: '内蒙古自治区')
neimeng.save
names = [ '呼和浩特', '包头', '乌海', '赤峰', '通辽', '鄂尔多斯', '呼伦贝尔', '巴彦淖尔', '乌兰察布', '兴安盟', '锡林郭勒盟', '阿拉善盟' ]
names.each do |name|
  neimeng.cities.create(name: name)
end

liaoning = Province.new(name: '辽宁')
liaoning.save
names = [ '沈阳', '大连', '鞍山', '抚顺', '本溪', '丹东', '锦州', '营口', '阜新', '辽阳', '盘锦', '铁岭', '朝阳', '葫芦岛' ]
names.each do |name|
  liaoning.cities.create(name: name)
end

jilin = Province.new(name: '吉林')
jilin.save
names = [ '长春', '吉林', '四平', '辽源', '通化', '白山', '松原', '白城', '延边朝鲜族自治' ]
names.each do |name|
  jilin.cities.create(name: name)
end
 
heilongjiang = Province.new(name: '黑龙江')
heilongjiang.save
names = [ '哈尔滨', '齐齐哈尔', '鸡西', '鹤岗', '双鸭山', '大庆', '伊春', '佳木斯', '七台河', '牡丹江', '黑河', '绥化', '大兴安岭地区' ]
names.each do |name|
  heilongjiang.cities.create(name: name)
end

jiangsu = Province.new(name: '江苏')
jiangsu.save
names = [ '南京', '无锡', '徐州', '常州', '苏州', '南通', '连云港', '淮安', '盐城', '扬州', '镇江', '泰州', '宿迁' ]
names.each do |name|
  jiangsu.cities.create(name: name)
end

zhejiang = Province.new(name: '浙江')
zhejiang.save
names = [ '杭州', '宁波', '温州', '嘉兴', '湖州', '绍兴', '金华', '衢州', '舟山', '台州', '丽水' ]
names.each do |name|
  zhejiang.cities.create(name: name)
end

anhui = Province.new(name: '安徽')
anhui.save
names = [ '合肥', '芜湖', '蚌埠', '淮南', '马鞍山', '淮北', '铜陵', '安庆', '黄山', '滁州', '阜阳', '宿州', '六安', '亳州', '池州', '宣城' ]
names.each do |name|
  anhui.cities.create(name: name)
end

fujian = Province.new(name: '福建')
fujian.save
names = [ '福州', '厦门', '莆田', '三明', '泉州', '漳州', '南平', '龙岩', '宁德' ]
names.each do |name|
  fujian.cities.create(name: name)
end

jiangxi = Province.new(name: '江西')
jiangxi.save
names = [ '南昌', '景德镇', '萍乡', '九江', '新余', '鹰潭', '赣州', '吉安', '宜春', '抚州', '上饶' ]
names.each do |name|
  jiangxi.cities.create(name: name)
end

shandong = Province.new(name: '山东')
shandong.save
names = [ '济南', '青岛', '淄博', '枣庄', '东营', '烟台', '潍坊', '济宁', '泰安', '威海', '日照', '莱芜', '临沂', '德州', '聊城', '滨州', '菏泽' ]
names.each do |name|
  shandong.cities.create(name: name)
end

henan = Province.new(name: '河南')
henan.save
names = [ '郑州', '开封', '洛阳', '平顶山', '安阳', '鹤壁', '新乡', '焦作', '濮阳', '许昌', '漯河', '三门峡', '南阳', '商丘', '信阳', '周口', '驻马店', '直辖县级行政区划' ]
names.each do |name|
  henan.cities.create(name: name)
end

hubei = Province.new(name: '湖北')
hubei.save
names = [ '武汉', '黄石', '十堰', '宜昌', '襄阳', '鄂州', '荆门', '孝感', '荆州', '黄冈', '咸宁', '随州', '恩施土家族苗族自治州', '直辖县级行政区划' ]
names.each do |name|
  hubei.cities.create(name: name)
end

hunan = Province.new(name: '湖南')
hunan.save
names = [ '长沙', '株洲', '湘潭', '衡阳', '邵阳', '岳阳', '常德', '张家界', '益阳', '郴州', '永州', '怀化', '娄底', '湘西土家族苗族自治州' ]
names.each do |name|
  hunan.cities.create(name: name)
end

guangdong = Province.new(name: '广东')
guangdong.save
names = [ '广州', '韶关', '深圳', '珠海', '汕头', '佛山', '江门', '湛江', '茂名', '肇庆', '惠州', '梅州', '汕尾', '河源', '阳江', '清远', '东莞', '中山', '潮州', '揭阳', '云浮' ]
names.each do |name|
  guangdong.cities.create(name: name)
end

guangxi = Province.new(name: '广西壮族自治区')
guangxi.save
names = [ '南宁', '柳州', '桂林', '梧州', '北海', '防城港', '钦州', '贵港', '玉林', '百色', '贺州', '河池', '来宾', '崇左' ]
names.each do |name|
  guangxi.cities.create(name: name)
end

hainan = Province.new(name: '海南')
hainan.save
names = [ '海口', '三沙', '三亚', '直辖县级行政区划' ]
names.each do |name|
  hainan.cities.create(name: name)
end

sichuan = Province.new(name: '四川')
sichuan.save
names = [ '成都', '自贡', '攀枝花', '泸州', '德阳', '绵阳', '广元', '遂宁', '内江', '乐山', '南充', '眉山', '宜宾', '广安', '达州', '雅安', '巴中', '资阳', '阿坝藏族羌族自治州', '甘孜藏族自治州', '凉山彝族自治州' ]
names.each do |name|
  sichuan.cities.create(name: name)
end

guizhou = Province.new(name: '贵州')
guizhou.save
names = [ '贵阳', '六盘水', '遵义', '安顺', '毕节', '铜仁', '黔西南布依族苗族自治州', '黔东南苗族侗族自治州', '黔南布依族苗族自治州' ]
names.each do |name|
  guizhou.cities.create(name: name)
end

yunnan = Province.new(name: '云南')
yunnan.save
names = [ '昆明', '曲靖', '玉溪', '保山', '昭通', '丽江', '普洱', '临沧', '楚雄彝族自治州', '红河哈尼族彝族自治州', '文山壮族苗族自治州', '西双版纳傣族自治州', '大理白族自治州', '德宏傣族景颇族自治州', '怒江傈僳族自治州', '迪庆藏族自治州' ]
names.each do |name|
  yunnan.cities.create(name: name)
end

xizang = Province.new(name: '西藏自治区')
xizang.save
names = [ '拉萨', '昌都地区', '山南地区', '日喀则地区', '那曲地区', '阿里地区', '林芝地区' ]
names.each do |name|
  xizang.cities.create(name: name)
end

shanxi = Province.new(name: '陕西')
shanxi.save
names = [ '西安', '铜川', '宝鸡', '咸阳', '渭南', '延安', '汉中', '榆林', '安康', '商洛' ]
names.each do |name|
  shanxi.cities.create(name: name)
end

gansu = Province.new(name: '甘肃')
gansu.save
names = [ '兰州', '嘉峪关', '金昌', '白银', '天水', '武威', '张掖', '平凉', '酒泉', '庆阳', '定西', '陇南', '临夏回族自治州', '甘南藏族自治州' ]
names.each do |name|
  gansu.cities.create(name: name)
end

qinghai = Province.new(name: '青海')
qinghai.save
names = [ '西宁', '海东地区', '海北藏族自治州', '黄南藏族自治州', '海南藏族自治州', '果洛藏族自治州', '玉树藏族自治州', '海西蒙古族藏族自治州' ]
names.each do |name|
  qinghai.cities.create(name: name)
end

ningxia = Province.new(name: '宁夏回族自治区')
ningxia.save
names = [ '银川', '石嘴山', '吴忠', '固原', '中卫' ]
names.each do |name|
  ningxia.cities.create(name: name)
end

xinjiang = Province.new(name: '新疆维吾尔自治区')
xinjiang.save
names = [ '乌鲁木齐', '克拉玛依', '吐鲁番地区', '哈密地区', '昌吉回族自治州', '博尔塔拉蒙古自治州', '巴音郭楞蒙古自治州', '阿克苏地区', '克孜勒苏柯尔克孜自治州', '喀什地区', '和田地区', '伊犁哈萨克自治州', '塔城地区', '阿勒泰地区', '自治区直辖县级行政区划' ]
names.each do |name|
  xinjiang.cities.create(name: name)
end

=end