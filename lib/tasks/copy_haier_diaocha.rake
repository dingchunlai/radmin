namespace :copy_haier_diaocha do
	desc "拷贝海尔热水器调查"
  task :form => :environment  do
    fs = Fdata.find(:all, :conditions => ['isdelete = 0 and formid in (?)', [166, 167, 168, 169, 170]], :limit => 736)
    fs.each do |f|
      nf = Fdata.new
      nf.isdelete = 0
      nf.formid = f.formid
      nf.userip = f.userip
      nf.status = 0
      nf.cdate = f.cdate
      nf.udate = f.udate
      nf.ptime = f.ptime
      nf.c1 = f.c1
      nf.c2 = f.c2
      nf.c3 = f.c3
      nf.c4 = f.c4
      nf.c5 = f.c5
      nf.c6 = f.c6
      nf.c7 = f.c7
      nf.c8 = f.c8
      nf.c9 = f.c9
      nf.c10 = f.c10
      nf.c11 = f.c11
      nf.c12 = f.c12
      nf.c13 = f.c13
      nf.c14 = f.c14
      nf.c15 = f.c15
      nf.c16 = f.c16
      nf.c17 = f.c17
      nf.c18 = f.c18
      nf.c19 = f.c19
      nf.c20 = f.c20
      nf.c21 = f.c21
      nf.c22 = f.c22
      nf.c23 = f.c23
      nf.c24 = f.c24

      if f.formid == 166 || f.formid == 168 || f.formid == 169
        nf.c16 = nil
        c18 = f.c18.to_s.split('年龄')
        nf.c18 = c18.length > 1 ? "年龄#{c18[1]}" : c18[0]
      elsif f.formid == 167
        nf.c15 = nil
        c17 = f.c17.to_s.split('年龄')
        nf.c17 = c17.length > 1 ? "年龄#{c17[1]}" : c17[0]
      elsif f.formid == 170
        nf.c2 = nil
        c4 = f.c4.to_s.split('年龄')
        nf.c4 = c4.length > 1 ? "年龄#{c4[1]}" : c4[0]
      end
      
      nf.c25 = 1
      nf.save
    end
  end

end