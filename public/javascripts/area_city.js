function change_area(area){
	for (var c in city){
		if (city[c][0]==area)
		{
			for(i=document.all.city.options.length-1;i>=0;i--)
			{
				document.all.city.options.remove(i);
			}

			city_name = city[c][1].split(",");
			city_value = city[c][2].split(",");
			for (var i=0;i<city_name.length;i++)
			{
				document.all.city.options.add(new Option(city_name[i],city_value[i])); 
			}

		}
	}
}

var area_text = new Array();
var area_value = new Array();
var city=new Array();

var citynum=0;

area_value[citynum]='11910';
area_text[citynum]='�Ϻ���';
city[0]=new Array('11910','¬����,�����,�ֶ�����,բ����,������,��ɽ��,������,��ɽ��,������,������,�ϻ���,������,������,�����,������,�ζ���,�Ϻ�����,������,������,�ɽ���','12210,12228,12212,12213,12214,12215,12216,12217,12218,12220,12221,12222,12223,12224,12225,12226,12749,12219,12227,12211');

citynum++;
area_value[citynum]='11905';
area_text[citynum]='����';
city[1]=new Array('11905','������,������,������,ʯ��ɽ��,������,��̨��,������,������,������,������,������,ͨ����,��ƽ��','12335,12336,12339,12340,12341,12342,12338,12344,12345,12346,12347,12337,12343');

citynum++;
area_value[citynum]='11906';
area_text[citynum]='�㶫';
city[2]=new Array('11906','��ɽ,��Դ,տ��,�Ƹ�,����,��ݸ,��ͷ,����,����,÷��,ï��,����,��Զ,��β,����,����,��ɽ,��������,�ع�,����','11967,11977,11969,11970,11971,11972,11973,11974,11975,11978,11979,11980,11981,11982,11983,11984,11986,11985,11976,11968');

citynum++;
area_value[citynum]='31958';
area_text[citynum]='����';
city[3]=new Array('31958','������,������,��ɽ��,������,�޺���,������','31972,31973,31977,31975,31976,31974');

citynum++;
area_value[citynum]='11882';
area_text[citynum]='ɽ��';
city[4]=new Array('11882','����,����,����,��Ӫ,����,����,����,����,̩��,�Ͳ�,Ϋ��,��ׯ,����,��̨,�ĳ�,�ൺ,����','12170,12174,12172,12175,12176,12177,12178,12179,12180,12181,12182,12183,12184,12185,12186,12173,12171');


citynum++;
area_value[citynum]='11884';
area_text[citynum]='����';
city[5]=new Array('11884','��ӹ���������������,��˫���ɴ���������,��Ϫ,ŭ��������������,��������������,����,�º���徰����������,�������������,����,�ٲ�,˼é,��ɽ,����,��������������,��ͨ,��ɽ׳������������','12280,12295,12283,12284,12285,12288,12289,12291,12292,12282,12286,12290,12294,12287,12293,12281');



citynum++;
area_value[citynum]='11885';
area_text[citynum]='����';
city[6]=new Array('11885','����,�żҸ�,����,�γ�,����,����,��,����,�Ͼ�,��ͨ,����,̩��,��Ǩ,����,���Ƹ�','12111,37230,12114,12115,12117,12118,12119,12121,12122,12110,12112,12116,12120,37229,12113');



citynum++;
area_value[citynum]='11886';
area_text[citynum]='���ɹ�';
city[7]=new Array('11886','���ױ���,���,������˹,�ں�,��ͷ,�˰���,ͨ��,�����׶���,���ֹ�����,��������,�����첼,���ͺ���','12148,12149,12150,12151,12154,12153,12157,12158,12147,12152,12155,12156');



citynum++;
area_value[citynum]='11887';
area_text[citynum]='���';
city[8]=new Array('11887','������,������,��ƽ��,���,�ӱ���,�Ͽ���,�Ӷ���','12250,12251,12252,12253,12255,12256,12254');



citynum++;
area_value[citynum]='11888';
area_text[citynum]='����';
city[9]=new Array('11888','����,����,����,����,���,����,���Ǹ�,����,����,����,��ɫ,�ӳ�,����,����','11987,11988,11989,11990,11991,11992,11995,11996,11997,11998,11999,12000,11994,11993');



citynum++;
area_value[citynum]='11889';
area_text[citynum]='�㽭';
city[10]=new Array('11889','����,����,��ɽ,̨��,����,��,��ˮ,����,����,����,����','12296,12297,12299,12300,12301,12305,12304,12306,12298,12302,12303');



citynum++;
area_value[citynum]='11890';
area_text[citynum]='����';
city[11]=new Array('11890','��Ҵ,���ϲ���������,��Ȫ,���,��ˮ,����,���Ļ���������,������,����,ƽ��,����,¤��,����,����','11955,11956,11957,11958,11959,11960,11966,11962,11963,11964,11965,11953,11954,11961');



citynum++;
area_value[citynum]='11891';
area_text[citynum]='������';
city[12]=new Array('11891','�绯,���˰���,������,�ں�,��ľ˹,����,ĵ����,��̨��,�������,�׸�,����,˫Ѽɽ,����','12067,12068,12069,12070,12071,12072,12079,12074,12075,12076,12077,12078,12073');



citynum++;
area_value[citynum]='11892';
area_text[citynum]='����';
city[13]=new Array('11892','��ˮ����������,������,������������������,����,�Ͳ���,����,��ͤ��������������,�ֶ�����������,����,����,����,�Ĳ�,��������������,�ٸ���,��ɳ����������,��ָɽ,������,����','12010,12026,12012,12013,12014,12015,12018,12019,12020,12021,12022,12023,12024,12025,12009,12016,12017,12011');



citynum++;
area_value[citynum]='11893';
area_text[citynum]='����';
city[14]=new Array('11893','ͭ��,����,ǭ�������嶱��������,ǭ���ϲ���������������,��˳,����ˮ,����,�Ͻ�','12001,12002,12003,12005,12006,12007,12008,12004');



citynum++;
area_value[citynum]='11895';
area_text[citynum]='����';
city[15]=new Array('11895','����,Ǳ��,�Ƹ�,����,Т��,��ũ������,����,����,ʮ��,��ʩ����������������,�差,����,�˲�,����,�人,��ʯ,����','12080,12096,12082,12083,12084,12085,12086,12087,12088,12090,12091,12095,12089,12092,12093,12094,12081');



citynum++;
area_value[citynum]='11896';
area_text[citynum]='�ӱ�';
city[16]=new Array('11896','��̨,�żҿ�,�е�,ʯ��ׯ,�ػʵ�,�ȷ�,����,����,����,��ɽ,��ˮ','12027,12028,12029,12030,12031,12035,12033,12036,12037,12034,12032');



citynum++;
area_value[citynum]='11897';
area_text[citynum]='����';
city[17]=new Array('11897','�տ���,��֥,����,����,����,ɽ��,����','12258,12259,12260,12263,12261,12262,12257');



citynum++;
area_value[citynum]='11898';
area_text[citynum]='����';
city[18]=new Array('11898','��������������������,�żҽ�,����,����,����,����,����,����,����,¦��,��ɳ,��̶,����','12097,12098,12099,12101,12102,12103,12104,12106,12107,12108,12109,12100,12105');



citynum++;
area_value[citynum]='11899';
area_text[citynum]='����';
city[19]=new Array('11899','����,����,Ȫ��,����,����,��ƽ,����,����,����','11944,11945,11946,11947,11952,11949,11950,11951,11948');



citynum++;
area_value[citynum]='11900';
area_text[citynum]='����';
city[20]=new Array('11900','ƽ��ɽ,����,����,����,פ����,�ױ�,����,����,����,֣��,����,���,����,���,����,��Դ,����Ͽ','12050,12062,12052,12053,12054,12055,12056,12057,12058,12059,12060,12063,12064,12065,12066,12061,12051');



citynum++;
area_value[citynum]='11901';
area_text[citynum]='�½�';
city[21]=new Array('11901','������,���������ɹ�������,���������ɹ�������,��³ľ��,�����,������,����,�������տ¶�����������,���������������,ͼľ���,��ʲ,��������������,��³��,��������,����,ʯ����','12264,12277,12267,12268,12270,12271,12272,12273,12275,12279,12265,12269,12274,12278,12276,12266');



citynum++;
area_value[citynum]='11902';
area_text[citynum]='����';
city[22]=new Array('11902','�ߺ�,�Ϸ�,����,����,����,����,����ɽ,����,ͭ��,����,����,����,��ɽ,����,����,����','11912,11921,11914,11915,11916,11917,11918,11919,11922,11923,11924,11925,11926,11927,11920,11913');



citynum++;
area_value[citynum]='11903';
area_text[citynum]='����';
city[23]=new Array('11903','����,��˳,�̽�,��Ϫ,����,��ɽ,����,����,����,����,����,����,��«��,Ӫ��','12133,12134,12135,12137,12138,12140,12144,12142,12143,12145,12146,12136,12139,12141');






citynum++;
area_value[citynum]='11907';
area_text[citynum]='����';
city[24]=new Array('11907','����,����,��Դ,�ӱ߳�����������,��ƽ,ͨ��,�׳�,��ɽ','12349,12350,12351,12348,12353,12354,12355,12352');



citynum++;
area_value[citynum]='11908';
area_text[citynum]='����';
city[25]=new Array('11908','����,�潭��,�ϴ���,��ɽ��,��Ϫ��,ʯ��������������,������,��ƽ��,�뽭��,������,����,��¡��,�ɽ��,�ᶼ��,�ǿ���,��ˮ����������������,������,��������������������,��ɽ����������������,������,ͭ����,�ϴ���,�����,������,������,�ٲ���','12307,12329,12310,12311,12312,12313,12314,12315,12316,12317,12318,12321,12322,12323,12324,12325,12326,12327,12330,12331,12332,12309,12319,12320,12328,12308');



citynum++;
area_value[citynum]='11909';
area_text[citynum]='�ຣ';
city[26]=new Array('11909','���ϲ���������,�������������,�����ɹ������������,����,��������������,���ϲ���������,��������������,����','12165,12166,12167,12164,12163,12168,12162,12169');



citynum++;
area_value[citynum]='11911';
area_text[citynum]='�Ĵ�';
city[27]=new Array('11911','���Ӳ���Ǽ��������,�ɶ�,�ڽ�,��ɽ����������,����,�ϳ�,�㰲,�Ű�,��֦��,üɽ,����,���β���������,����,��Ԫ,����,�Թ�,�˱�,����,��ɽ,����,����','12229,12243,12231,12232,12233,12235,12236,12237,12239,12240,12244,12246,12247,12248,12234,12238,12241,12245,12249,12242,12230');




citynum++;
area_value[citynum]='31959';
area_text[citynum]='����';
city[28]=new Array('31959','������,������,��ɳ��,Խ����,�����,������,�ӻ���,������,�ܸ���,��خ��,������,������','31960,31961,31962,31963,31964,31971,31966,31967,31968,31969,31970,31965');



citynum++;
area_value[citynum]='32540';
area_text[citynum]='ȫ��';
city[29]=new Array('32540','ȫ������','32558');



citynum++;
area_value[citynum]='11881';
area_text[citynum]='����';
city[30]=new Array('11881','����,��ԭ,����','12160,12159,12161');



citynum++;
area_value[citynum]='11894';
area_text[citynum]='����';
city[31]=new Array('11894','����,����,������,����,Ƽ��,ӥ̶,�Ž�,�ϲ�,����,�˴�','12123,12125,12126,12127,12124,12128,12132,12130,12131,12129');



citynum++;
area_value[citynum]='11904';
area_text[citynum]='ɽ��';
city[32]=new Array('11904','����,����,����,�ٷ�,����,˷��,����,��Ȫ,��ͬ,�˳�,̫ԭ','12187,12188,12189,12192,12193,12191,12195,12196,12197,12190,12194');



citynum++;
area_value[citynum]='11883';
area_text[citynum]='����';
city[33]=new Array('11883','����,����,μ��,ͭ��,����,�Ӱ�,����,����,����,����','12198,12199,12200,12201,12206,12203,12207,12208,12204,12202');



citynum++;
