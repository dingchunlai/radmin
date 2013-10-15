# == Schema Information
#
# Table name: HEJIA_CASE
#
#  ID              :integer(19)     not null, primary key
#  REMARK          :string(2000)
#  CREATEDATE      :datetime
#  HOSTIMAGE       :string(510)
#  HOSTINFO        :string(2000)
#  INTRODUCE       :string(2000)
#  NAME            :string(510)
#  NEEDPAY         :integer(1)
#  TEMPLATE        :string(510)
#  URL             :string(510)
#  COMPANYID       :integer(19)
#  STATUS          :string(510)
#  EDITORID        :integer(19)
#  LASTMODIFYTIME  :datetime
#  CONTRACTID      :integer(19)
#  BUILDINGNAME    :string(510)
#  DECOCOST        :integer(19)
#  DESIGNCOST      :integer(19)
#  DESIGNERCOMMENT :string(4000)
#  HOSTCOMMENT     :string(4000)
#  HOUSEAREA       :integer(19)
#  HOUSETYPE       :string(510)
#  DESIGNERID      :integer(19)
#  DESIGNMETHOD    :string(4000)
#  ISNEWCASE       :integer(1)
#  ISGOOD          :integer(10)
#  ISCHANGED       :string(510)
#  ISCHOICENESS    :string(510)
#  ISCOMMEND       :string(510)
#  ISPASS          :string(510)
#  BACKREASON      :string(510)
#  MODIFYID        :integer(19)
#  REPORTERID      :integer(19)
#  MAINPHOTO       :string(510)
#  PRAISINGCOUNT   :integer(19)
#  CRITICISMCOUNT  :integer(19)
#  PROVINCE1       :integer(19)
#  PROVINCE2       :integer(19)
#  DOWNLOADNUM     :integer(19)
#  USERTAGNUM      :integer(19)
#  UPLOADNUM       :integer(19)
#  SHARENUM        :integer(19)
#  LIBANGCOUNT     :integer(10)
#  ISZHUANGHUANG   :string(255)
#  HUXINGORDER     :integer(10)
#  YUSUANORDER     :integer(10)
#  FENGGEORDER     :integer(10)
#  YONGTUORDER     :integer(10)
#  VIEWCOUNT       :integer(10)
#  CASEUP          :integer(10)     default(0)
#  CASEDOWN        :integer(10)     default(0)
#  TYPE_ID         :integer(4)
#  ENTITY_ID       :integer(10)
#  STATE           :integer(11)     default(1)
#  ischeck         :integer(11)
#  address         :string(255)
#  matrial         :string(150)
#

require File.dirname(__FILE__) + '/../test_helper'

class ExcelcaseTest < Test::Unit::TestCase
  fixtures :excelcases

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
