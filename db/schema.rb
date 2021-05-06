# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_16_042533) do

  create_table "attachfiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "reportid", null: false
    t.json "filename"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reportid"], name: "id_idx"
  end

  create_table "idx_auth", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "idx_ccu_id", limit: 20
    t.string "s_nm", limit: 20
    t.string "shop_id", limit: 20
    t.string "shop_nm", limit: 20
    t.string "b_id", limit: 20
    t.string "b_nm", limit: 20
    t.string "ccu_pw", limit: 20
    t.string "ccu_nm", limit: 20
    t.string "dpt_nm", limit: 20
    t.string "bb_shoplist", limit: 100, comment: "실적보고업장"
    t.string "P00", limit: 2, comment: "메인화면"
    t.string "bb101", limit: 2, comment: "홀딩스"
    t.string "bb102", limit: 2, comment: "임원"
    t.string "bb103", limit: 2, comment: "건축기획"
    t.string "bb104", limit: 2, comment: "마케팅"
    t.string "bb201", limit: 2, comment: "그룹장"
    t.string "bb202", limit: 2, comment: "1사업부"
    t.string "bb203", limit: 2, comment: "2사업부"
    t.string "bb204", limit: 2, comment: "일/중식사업부"
    t.string "bb205", limit: 2, comment: "자작나무"
    t.string "bb206", limit: 2, comment: "독립사업부"
    t.string "bb207", limit: 2, comment: "돈블랑"
    t.string "bb208", limit: 2, comment: "카페&베이커리"
    t.string "remember_token"
    t.integer "mlevel", comment: "권한레벨"
    t.string "msg_token"
    t.integer "plevel", limit: 1
    t.index ["idx_ccu_id"], name: "idx_ccu_id"
  end

  create_table "idx_auth_new", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "idx_ccu_id", limit: 20
    t.string "s_nm", limit: 20
    t.string "shop_id", limit: 20
    t.string "shop_nm", limit: 20
    t.string "b_id", limit: 20
    t.string "b_nm", limit: 20
    t.string "ccu_pw", limit: 20
    t.string "ccu_nm", limit: 20
    t.string "dpt_nm", limit: 20
    t.string "bb_shoplist", limit: 100
    t.string "P00", limit: 2
    t.string "bb101", limit: 2
    t.string "bb102", limit: 2
    t.string "bb103", limit: 2
    t.string "bb104", limit: 2
    t.string "bb201", limit: 2
    t.string "bb202", limit: 2
    t.string "bb203", limit: 2
    t.string "bb204", limit: 2
    t.string "bb205", limit: 2
    t.string "bb206", limit: 2
    t.string "bb207", limit: 2
    t.string "bb208", limit: 2
    t.string "remember_token"
    t.integer "mlevel"
  end

  create_table "idx_b", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "b_id", limit: 20, comment: "그룹 아이디"
    t.string "b_nm", limit: 20, comment: "그룹명"
    t.string "s_id", limit: 20, comment: "사업부 아이디"
    t.string "s_nm", limit: 20, comment: "사업부명"
    t.integer "b_sort", comment: "그룹 정렬"
  end

  create_table "idx_bshop", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "s_id", limit: 20, null: false
    t.string "shop_id", limit: 20, null: false
    t.string "shop_nm", limit: 20
    t.integer "shop_sort"
    t.string "b_id", limit: 20
    t.string "b_nm", limit: 20
    t.integer "b_sort"
  end

  create_table "idx_ccu_id", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "idx_ccu_id", limit: 20
    t.string "h_id", limit: 20, comment: "신화푸드그룹 id (버리는 필드, 자작때문에 당분간 필요)"
    t.string "h_nm", limit: 20, comment: "신화푸드그룹 이름 (버리는 필드, 자작때문에 필요)"
    t.string "s_id", limit: 20, comment: "사업부 아이디"
    t.string "s_nm", limit: 20, comment: "사업부 이름"
    t.string "shop_id", limit: 20, comment: "업장 아이디"
    t.string "shop_nm", limit: 50, comment: "업장 이름"
    t.string "b_id", limit: 20, comment: "그룹 아이디"
    t.string "b_nm", limit: 20, comment: "그룹 이름"
    t.string "ccu_id", limit: 20, comment: "큐브센터등록아이디"
    t.string "ccu_pw", limit: 20, comment: "큐브센터등록비밀번호"
    t.string "ccu_nm", limit: 20, comment: "큐브센터 이름"
    t.string "ccu_st", limit: 20
    t.string "p_id", limit: 20
    t.string "trd_id", limit: 20
    t.string "sct_id", limit: 20, comment: "권한설정 아이디"
    t.string "dpt_id", limit: 20
    t.string "dpt_nm", limit: 20
  end

  create_table "idx_div", primary_key: "div_id", id: :string, limit: 20, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "div_sort", null: false
    t.string "div_nm", limit: 20
  end

  create_table "idx_divshop", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "s_id", limit: 20, null: false
    t.string "shop_id", limit: 20, null: false
    t.string "shop_nm", limit: 20
    t.integer "shop_sort"
    t.integer "shop_sort_platform"
    t.string "div_id", limit: 20
    t.string "div_nm", limit: 20
    t.integer "div_sort"
  end

  create_table "idx_dpt", primary_key: "dpt_id", id: :string, limit: 20, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "dpt_nm", limit: 20, null: false
  end

  create_table "idx_fovi", primary_key: "fv_id", id: :string, limit: 20, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "fv_sort", null: false
    t.string "fv_nm", limit: 20
  end

  create_table "idx_fovishop", primary_key: "shop_id", id: :string, limit: 20, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "shop_nm", limit: 20, null: false
    t.integer "shop_sort"
    t.integer "shop_sort_platform"
    t.string "fv_id", limit: 20
    t.integer "fv_sort"
    t.string "fv_nm", limit: 20
  end

  create_table "idx_gdmj", primary_key: "gdmj_id", id: :string, limit: 20, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "gdmj_nm", limit: 20, null: false
  end

  create_table "idx_gdmr", primary_key: ["no", "gdmr_ids"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "no", null: false, comment: "일련번호", auto_increment: true
    t.string "s_id", limit: 100, null: false, comment: "사업부아이디"
    t.string "s_nm", limit: 100, comment: "사업부명"
    t.string "gdmr_id", limit: 100, comment: "소분류아이디_큐브"
    t.string "gdmr_nm", limit: 100, comment: "소분류명_큐브"
    t.string "gdmr_ids", limit: 100, null: false, comment: "사업부아이디+소분류아이디"
    t.string "gdmj_nm", limit: 100, comment: "중분류명"
    t.string "gdmj_id", limit: 100, comment: "중분류아이디"
    t.integer "gdmr_sort", comment: "소분류 정렬"
  end

  create_table "idx_invt", primary_key: ["h_id", "s_id", "shop_id", "gd_id"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "h_id", limit: 10, null: false
    t.string "s_id", limit: 10, null: false
    t.string "shop_id", limit: 10, null: false
    t.string "gd_id", limit: 10, null: false
    t.string "gd_nm", limit: 100
    t.string "unit_id", limit: 10
    t.string "gdmr_id", limit: 10
    t.string "live_yn", limit: 1
    t.decimal "gd_bsn_unit_per", precision: 6, scale: 2
    t.string "gd_bsn_unit_id", limit: 10
    t.decimal "gd_stk_gd_per", precision: 6, scale: 2
    t.string "memo", limit: 200
    t.string "cret_usrid", limit: 20
    t.datetime "cret_dt"
    t.string "mod_usrid", limit: 20
    t.datetime "mod_dt"
  end

  create_table "idx_pages", primary_key: "bb_id", id: :string, limit: 20, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "bb_nm", limit: 20
    t.string "bb_nm_short", limit: 20
    t.index ["bb_id"], name: "bb_id"
  end

  create_table "idx_s", primary_key: "s_id", id: :string, limit: 10, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "s_nm", limit: 10, null: false
    t.string "s_nm_short", limit: 10
    t.integer "s_sort"
  end

  create_table "idx_sct", primary_key: "sct_id", id: :string, limit: 20, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "sct_nm", limit: 20, null: false
    t.string "sct_ref", limit: 20
  end

  create_table "idx_sfgplcat1", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "plcat1_id", limit: 20
    t.string "plcat1_nm", limit: 20
  end

  create_table "idx_sfgplcat2", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "plcat2_id", limit: 20
    t.string "plcat2_nm", limit: 20
    t.string "plcat1_id", limit: 20
    t.string "plcat1_nm", limit: 20
  end

  create_table "idx_shop", primary_key: ["shop_id", "s_id", "h_id"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "h_id", limit: 10, null: false
    t.string "s_id", limit: 10, null: false
    t.string "shop_id", limit: 10, null: false
    t.string "h_nm", limit: 50
    t.string "s_nm", limit: 50
    t.string "shop_nm", limit: 50
    t.string "shoppt_nm", limit: 50
    t.string "if_id", limit: 20
    t.string "shop_suw_id", limit: 10
    t.string "shop_biz_no", limit: 15
    t.string "shop_onr_nm", limit: 30
    t.string "shop_key_tel", limit: 15
    t.string "shop_ads_info", limit: 100
    t.string "b_id", limit: 10
    t.string "memo", limit: 200
    t.datetime "shop_open_dt"
    t.datetime "shop_close_dt"
    t.string "etax_shop_nm", limit: 100
    t.string "cret_usrid", limit: 20
    t.datetime "cret_dt"
    t.string "mod_usrid", limit: 20
    t.datetime "mod_dt"
  end

  create_table "idx_shopsort", primary_key: "shop_id", id: :string, limit: 20, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "shop_nm", limit: 20, comment: "업장명"
    t.integer "shop_sort", comment: "업장순서\n"
    t.string "b_id", limit: 20, null: false, comment: "그룹아이디"
    t.string "b_nm", limit: 20, comment: "그룹명"
    t.integer "b_sort", comment: "그룹순서"
    t.string "s_id", limit: 20, comment: "사업부아이디"
    t.string "s_nm", limit: 20, comment: "사업부명"
    t.string "s_nm_short", limit: 20, comment: "사업부명축소"
    t.string "m_id", limit: 20, comment: "브랜드아이디"
    t.string "m_nm", limit: 20, comment: "브랜드명"
    t.string "fv_id", limit: 20, comment: "푸드빌아이디"
    t.string "fv_sort", limit: 20, comment: "푸드빌순서"
    t.string "fv_nm", limit: 20, comment: "푸드빌명"
    t.integer "shop_sort_platform", comment: "플랫폼업장순서"
    t.string "div_id", limit: 20, comment: "부분사업부아이디"
    t.string "div_nm", limit: 20, comment: "부분사업부명"
    t.integer "div_sort", comment: "부분사업부순서"
  end

  create_table "idx_shoptotal", primary_key: "shop_id", id: :string, limit: 20, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "shop_nm", limit: 20
    t.integer "shop_sort"
    t.string "b_id", limit: 20
    t.string "b_nm", limit: 20
    t.integer "b_sort"
    t.string "s_id", limit: 20
    t.string "s_nm", limit: 20
    t.string "s_nm_short", limit: 20
    t.string "m_id", limit: 20
    t.string "m_nm", limit: 20
    t.string "fv_id", limit: 20
    t.integer "fv_sort"
    t.string "fv_nm", limit: 20
    t.integer "shop_sort_platform"
    t.string "div_id", limit: 20
    t.string "div_nm", limit: 20
    t.integer "div_sort"
    t.string "s_nm_div", limit: 100
  end

  create_table "reportrooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "roomtype", null: false
    t.string "userid", null: false
    t.text "contents"
    t.text "plancontents"
    t.string "bb_shoplist"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reportrooms_readinfos", primary_key: ["roomtype", "reportid", "userid"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "roomtype", null: false
    t.bigint "reportid", null: false
    t.string "userid", null: false
    t.datetime "first_read_at"
    t.datetime "last_read_at"
  end

  create_table "tb_cos_daily", primary_key: ["h_id", "s_id", "shop_id", "bsn_dt"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "h_id", limit: 10, null: false
    t.string "s_id", limit: 10, null: false
    t.string "shop_id", limit: 10, null: false
    t.datetime "bsn_dt", null: false
    t.string "b_id", limit: 10
    t.string "shop_nm", limit: 50
    t.integer "shop_sort", limit: 2
    t.decimal "sbg_real_amt", precision: 13, scale: 2
    t.decimal "sb_avg_amt", precision: 12, scale: 2
    t.decimal "sog_real_amt", precision: 38, scale: 2
    t.decimal "sog_rate", precision: 38, scale: 6
  end

  create_table "tb_invt", primary_key: ["h_id", "s_id", "shop_id", "gd_id", "so_date"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "h_id", limit: 10, null: false
    t.string "s_id", limit: 10, null: false
    t.string "b_id", limit: 10
    t.string "shop_id", limit: 10, null: false
    t.string "gd_id", limit: 10, null: false
    t.datetime "so_date", null: false
    t.string "shop_nm", limit: 50
    t.integer "shop_sort", limit: 2
    t.string "gd_nm", limit: 100
    t.string "unit_id", limit: 10
    t.decimal "min_qty", precision: 10, scale: 2
    t.decimal "max_qty", precision: 10, scale: 2
    t.decimal "bsn_qty", precision: 38, scale: 2
    t.decimal "prs_qty", precision: 38, scale: 2
    t.decimal "srate", precision: 38, scale: 6
    t.integer "real_qty"
    t.decimal "real_amt", precision: 38, scale: 2
    t.decimal "so_qty", precision: 38, scale: 2
    t.decimal "so_amt", precision: 38, scale: 2
  end

  create_table "tb_ppc_save", primary_key: ["h_id", "s_id", "ppce_no", "ppc_no"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "h_id", limit: 10, null: false
    t.string "s_id", limit: 10, null: false
    t.string "ppc_no", limit: 50, null: false
    t.integer "ppce_no", null: false
    t.string "b_id", limit: 20
    t.string "shop_id", limit: 20
    t.string "shop_nm", limit: 50
    t.integer "shop_sort", limit: 2
    t.datetime "bsn_dt"
    t.decimal "ppce_amt", precision: 12, scale: 2
    t.datetime "ppce_dt"
    t.string "bc_st", limit: 1
    t.decimal "ppce_crg_cash_amt", precision: 12, scale: 2
    t.decimal "ppce_crg_card_amt", precision: 12, scale: 2
    t.decimal "ppce_crg_oln_amt", precision: 12, scale: 2
    t.string "apv", limit: 1
    t.string "ppce_apv_nb", limit: 20
    t.string "card_nm", limit: 50
    t.decimal "ppce_add_amt", precision: 12, scale: 2
    t.decimal "ppce_use_amt", precision: 12, scale: 2
    t.decimal "ppce_avb_amt", precision: 12, scale: 2
    t.string "live_yn", limit: 1
  end

  create_table "tb_ppc_use", primary_key: ["h_id", "s_id", "shop_id", "bsn_dt", "bsn_no", "bc_no"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "h_id", limit: 10, null: false
    t.string "s_id", limit: 10, null: false
    t.string "shop_id", limit: 10, null: false
    t.datetime "bsn_dt", null: false
    t.integer "bsn_no", limit: 2, null: false
    t.integer "bc_no", limit: 2, null: false
    t.string "b_id", limit: 10
    t.string "shop_nm", limit: 50
    t.integer "shop_sort", limit: 2
    t.decimal "bc_amt", precision: 12, scale: 2
    t.string "bc_card_nb", limit: 30
    t.decimal "b_rcb_amt", precision: 12, scale: 2
    t.decimal "b_crt_amt", precision: 12, scale: 2
    t.decimal "b_cash_amt", precision: 12, scale: 2
    t.string "b_cash_rct_yn", limit: 1
    t.decimal "b_vcr_amt", precision: 12, scale: 2
    t.decimal "b_tick_amt", precision: 12, scale: 2
    t.decimal "b_pnt_amt", precision: 12, scale: 2
    t.decimal "b_svc_crg_amt", precision: 12, scale: 2
    t.integer "b_vst_cnt", limit: 2
    t.datetime "b_crg_dt"
  end

  create_table "tb_sales_bill", primary_key: ["h_id", "s_id", "shop_id", "bsn_dt", "bsn_no"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "h_id", limit: 10, null: false
    t.string "s_id", limit: 10, null: false
    t.string "shop_id", limit: 10, null: false
    t.datetime "bsn_dt", null: false
    t.integer "bsn_no", limit: 2, null: false
    t.string "b_id", limit: 10
    t.string "shop_nm", limit: 50
    t.integer "shop_sort", limit: 2
    t.string "stb_id", limit: 10
    t.datetime "b_odr_dt"
    t.datetime "b_crg_dt"
    t.string "b_odr_st", limit: 1
    t.string "b_st", limit: 1
    t.decimal "b_ccl_amt", precision: 12, scale: 2
    t.decimal "b_dst_amt", precision: 13, scale: 2
    t.decimal "b_rcb_amt", precision: 12, scale: 2
    t.integer "b_vst_cnt", limit: 2
    t.string "live_yn", limit: 1
    t.decimal "b_crt_amt", precision: 12, scale: 2
    t.decimal "b_cash_amt", precision: 12, scale: 2
    t.decimal "b_etc_amt", precision: 15, scale: 2
    t.string "gd_nm", limit: 1000
  end

  create_table "tb_sales_current", primary_key: ["h_id", "s_id", "shop_id", "bsn_dt", "bsn_no"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "h_id", limit: 10, null: false
    t.string "s_id", limit: 10, null: false
    t.string "shop_id", limit: 10, null: false
    t.datetime "bsn_dt", null: false
    t.integer "bsn_no", null: false
    t.string "b_id", limit: 20
    t.string "shop_nm", limit: 20
    t.integer "shop_sort"
    t.string "stb_id", limit: 20
    t.string "stbmr_id", limit: 20
    t.datetime "b_odr_dt"
    t.datetime "b_crg_dt"
    t.string "b_odr_st", limit: 20
    t.string "b_st", limit: 20
    t.decimal "b_rtn_amt", precision: 10, scale: 2
    t.decimal "b_amt", precision: 10, scale: 2
    t.decimal "b_ccl_amt", precision: 10, scale: 2
    t.decimal "b_gd_dst_amt", precision: 10, scale: 2
    t.decimal "b_dst_amt", precision: 10, scale: 2
    t.decimal "b_real_amt", precision: 10, scale: 2
    t.decimal "b_vos_amt", precision: 10, scale: 2
    t.decimal "b_tax_amt", precision: 10, scale: 2
    t.decimal "b_taxf_amt", precision: 10, scale: 2
    t.decimal "b_trd_amt", precision: 10, scale: 2
    t.decimal "b_svc_crg_amt", precision: 10, scale: 2
    t.decimal "b_rcb_amt", precision: 10, scale: 2
    t.decimal "b_cash_amt", precision: 10, scale: 2
    t.decimal "b_crt_amt", precision: 10, scale: 2
    t.decimal "b_vcr_amt", precision: 10, scale: 2
    t.decimal "b_tick_amt", precision: 10, scale: 2
    t.decimal "b_pnt_amt", precision: 10, scale: 2
    t.decimal "b_oln_amt", precision: 10, scale: 2
    t.decimal "b_rcv_amt", precision: 10, scale: 2
    t.decimal "b_smh_amt", precision: 10, scale: 2
    t.string "b_cash_rct_yn", limit: 20
    t.decimal "b_cash_rct_amt", precision: 10, scale: 2
    t.integer "b_vst_cnt"
    t.integer "b_odr_cnt"
    t.integer "b_odr_gd_cnt"
    t.string "b_tb_use_yn", limit: 20
    t.string "b_crg_st", limit: 20
    t.string "cs_id", limit: 20
    t.string "cs_card_nb", limit: 20
    t.string "b_bf_stb_id", limit: 20
    t.string "b_bf_stb_st", limit: 20
    t.string "b_suser_id", limit: 20
    t.string "b_crg_suser_id", limit: 20
    t.string "b_odr_pos_id", limit: 20
    t.string "b_crg_pos_id", limit: 20
    t.integer "b_bf_no"
    t.integer "b_bf_spt_no"
    t.string "b_tick_crg_st", limit: 20
    t.datetime "b_tick_crg_dt"
    t.string "css_id", limit: 20
    t.decimal "b_suser_amt", precision: 10, scale: 2
    t.string "b_trn_yn", limit: 20
    t.datetime "b_trn_dt"
    t.string "b_bill_msg", limit: 20
    t.decimal "b_etc_amt", precision: 10, scale: 2
    t.string "b_rtn_st", limit: 20
    t.string "b_rtn_id", limit: 20
    t.datetime "b_rtn_bsn_dt"
    t.integer "b_rtn_bsn_no"
    t.string "b_rtn_pt", limit: 20
    t.decimal "b_tick_in_amt", precision: 10, scale: 2
    t.integer "b_bsn_nb"
    t.string "b_shop_id", limit: 20
    t.string "del_id", limit: 20
    t.string "live_yn", limit: 20
    t.string "if_id", limit: 20
    t.text "memo"
    t.string "info", limit: 20
    t.string "cret_usrid", limit: 20
    t.datetime "cret_dt"
    t.string "mod_usrid", limit: 20
    t.datetime "mod_dt"
  end

  create_table "tb_sales_daily", primary_key: ["h_id", "s_id", "shop_id", "bsn_dt"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "h_id", limit: 10, null: false
    t.string "s_id", limit: 10, null: false
    t.string "shop_id", limit: 10, null: false
    t.datetime "bsn_dt", null: false
    t.string "b_id", limit: 10
    t.integer "ss_sort", limit: 2
    t.integer "shop_sort", limit: 2
    t.string "shop_nm", limit: 50
    t.decimal "sb_amt", precision: 12, scale: 2
    t.decimal "sb_rtn_amt", precision: 12, scale: 2
    t.decimal "sb_ccl_amt", precision: 12, scale: 2
    t.decimal "sb_gd_dst_amt", precision: 12, scale: 2
    t.decimal "sb_dst_amt", precision: 12, scale: 2
    t.decimal "sb_real_amt", precision: 12, scale: 2
    t.integer "sb_vst_cnt", limit: 2
    t.integer "sb_ord_cnt", limit: 2
    t.decimal "sb_vos_amt", precision: 12, scale: 2
    t.decimal "sb_tax_amt", precision: 12, scale: 2
    t.decimal "sb_taxf_amt", precision: 12, scale: 2
    t.decimal "sb_svc_crg_amt", precision: 12, scale: 2
    t.decimal "sb_tb_trv_per", precision: 5, scale: 2
    t.decimal "sb_rcb_amt", precision: 12, scale: 2
    t.decimal "sb_cash_amt", precision: 12, scale: 2
    t.decimal "sb_crt_amt", precision: 12, scale: 2
    t.decimal "sb_vcr_amt", precision: 12, scale: 2
    t.decimal "sb_tick_amt", precision: 12, scale: 2
    t.decimal "sb_cs_pnt_amt", precision: 12, scale: 2
    t.decimal "sb_oln_amt", precision: 12, scale: 2
    t.decimal "sb_mlt_amt", precision: 12, scale: 2
    t.decimal "sb_etc_amt", precision: 12, scale: 2
    t.decimal "sb_vcr_in_amt", precision: 12, scale: 2
    t.decimal "sb_tick_in_amt", precision: 12, scale: 2
    t.decimal "sb_etc_in_amt", precision: 12, scale: 2
    t.decimal "sb_cash_rct_cnt", precision: 12, scale: 2
    t.decimal "sb_cash_rct_amt", precision: 12, scale: 2
    t.integer "sb_ccl_cnt", limit: 2
    t.integer "sb_rtn_cnt", limit: 2
    t.integer "sb_shop_cnt", limit: 2
    t.integer "sb_pkg_cnt", limit: 2
    t.integer "sb_dlr_cnt", limit: 2
    t.decimal "sb_epse_amt", precision: 12, scale: 2
    t.datetime "sb_trn_dt"
    t.datetime "cret_dt"
    t.datetime "sb_to_dt"
    t.string "sb_mod_yn", limit: 1
    t.decimal "sb_fm_cash_amt", precision: 10, scale: 2
    t.decimal "sb_to_cash_amt", precision: 10, scale: 2
    t.string "memo", limit: 2000
  end

  create_table "tb_sales_detail", primary_key: ["h_id", "s_id", "shop_id", "bsn_dt", "bsn_no", "bg_no"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "h_id", limit: 10, null: false
    t.string "s_id", limit: 10, null: false
    t.string "shop_id", limit: 10, null: false
    t.datetime "bsn_dt", null: false
    t.integer "bsn_no", limit: 2, null: false
    t.integer "bg_no", limit: 2, null: false
    t.string "b_id", limit: 10
    t.string "shop_nm", limit: 50
    t.integer "shop_sort", limit: 2
    t.integer "b_vst_cnt", limit: 2
    t.string "gd_id", limit: 10
    t.string "gd_nm", limit: 100
    t.string "bg_st", limit: 1
    t.string "bg_odr_st", limit: 1
    t.string "bg_gd_st", limit: 10
    t.datetime "bg_odr_dt"
    t.datetime "bg_stt_dt"
    t.decimal "bg_qty", precision: 10, scale: 2
    t.decimal "bg_uc", precision: 12, scale: 2
    t.decimal "bg_amt", precision: 12, scale: 2
    t.decimal "bg_gd_dst_amt", precision: 12, scale: 2
    t.decimal "bg_dst_amt", precision: 12, scale: 2
    t.decimal "bg_real_amt", precision: 12, scale: 2
    t.decimal "bg_svc_crg_amt", precision: 12, scale: 2
    t.decimal "bg_vos_amt", precision: 12, scale: 2
    t.decimal "bg_tax_amt", precision: 12, scale: 2
    t.decimal "bg_apl_vos_amt", precision: 12, scale: 2
    t.decimal "bg_apl_tax_amt", precision: 12, scale: 2
    t.string "stb_id", limit: 50
    t.integer "bg_ord_sort_no", limit: 2
    t.decimal "bg_ord_qty", precision: 10, scale: 2
    t.string "bg_ord_pos_id", limit: 50
    t.string "bg_mod_pos_id", limit: 50
    t.string "del_id", limit: 50
    t.string "bg_ccl_id", limit: 10
    t.string "dst_id", limit: 50
    t.integer "bg_bf_bg_no", limit: 2
    t.string "bg_bf_stb_id", limit: 10
    t.string "bg_bill_msg", limit: 100
    t.string "bg_rtn_id", limit: 10
    t.datetime "bg_rtn_bsn_dt"
    t.integer "bg_rtn_bsn_no", limit: 2
    t.integer "bg_rtn_bg_no", limit: 2
    t.string "bg_new_gd_nm", limit: 100
    t.string "live_yn", limit: 1
    t.string "cret_usrid", limit: 20
    t.datetime "cret_dt"
    t.string "mod_usrid", limit: 20
    t.datetime "mod_dt"
  end

  create_table "tb_sfgbill", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "sfgbill_dt"
    t.string "shop_id", limit: 20
    t.integer "sfgbill_ym"
    t.integer "sfgbill_no"
    t.string "shop_nm", limit: 20
    t.decimal "sfgbill_farate", precision: 10, scale: 5
    t.decimal "sfgbill_salesf", precision: 15, scale: 6
    t.decimal "sfgbill_salesm", precision: 15, scale: 6
    t.decimal "sfgbill_sales", precision: 15, scale: 6
    t.decimal "sfgbill_bfwl", precision: 15, scale: 6
    t.decimal "sfgbill_bfwd", precision: 15, scale: 6
    t.decimal "sfgbill_bfwt", precision: 15, scale: 6
    t.decimal "sfgbill_bfhl", precision: 15, scale: 6
    t.decimal "sfgbill_bfhd", precision: 15, scale: 6
    t.decimal "sfgbill_bfht", precision: 15, scale: 6
    t.decimal "sfgbill_bfel", precision: 15, scale: 6
    t.decimal "sfgbill_bfed", precision: 15, scale: 6
    t.decimal "sfgbill_bfet", precision: 15, scale: 6
    t.decimal "sfgbill_bmwl", precision: 15, scale: 6
    t.decimal "sfgbill_bmwd", precision: 15, scale: 6
    t.decimal "sfgbill_bmwt", precision: 15, scale: 6
    t.decimal "sfgbill_bmhl", precision: 15, scale: 6
    t.decimal "sfgbill_bmhd", precision: 15, scale: 6
    t.decimal "sfgbill_bmht", precision: 15, scale: 6
    t.decimal "sfgbill_bmel", precision: 15, scale: 6
    t.decimal "sfgbill_bmed", precision: 15, scale: 6
    t.decimal "sfgbill_bmet", precision: 15, scale: 6
    t.decimal "sfgbill_bawl", precision: 15, scale: 6
    t.decimal "sfgbill_bawd", precision: 15, scale: 6
    t.decimal "sfgbill_bawt", precision: 15, scale: 6
    t.decimal "sfgbill_bahl", precision: 15, scale: 6
    t.decimal "sfgbill_bahd", precision: 15, scale: 6
    t.decimal "sfgbill_baht", precision: 15, scale: 6
    t.decimal "sfgbill_bael", precision: 15, scale: 6
    t.decimal "sfgbill_baed", precision: 15, scale: 6
    t.decimal "sfgbill_baet", precision: 15, scale: 6
    t.decimal "sfgbill_cfwl", precision: 15, scale: 6
    t.decimal "sfgbill_cfwd", precision: 15, scale: 6
    t.decimal "sfgbill_cfwt", precision: 15, scale: 6
    t.decimal "sfgbill_cfhl", precision: 15, scale: 6
    t.decimal "sfgbill_cfhd", precision: 15, scale: 6
    t.decimal "sfgbill_cfht", precision: 15, scale: 6
    t.decimal "sfgbill_cfel", precision: 15, scale: 6
    t.decimal "sfgbill_cfed", precision: 15, scale: 6
    t.decimal "sfgbill_cfet", precision: 15, scale: 6
    t.decimal "sfgbill_cmwl", precision: 15, scale: 6
    t.decimal "sfgbill_cmwd", precision: 15, scale: 6
    t.decimal "sfgbill_cmwt", precision: 15, scale: 6
    t.decimal "sfgbill_cmhl", precision: 15, scale: 6
    t.decimal "sfgbill_cmhd", precision: 15, scale: 6
    t.decimal "sfgbill_cmht", precision: 15, scale: 6
    t.decimal "sfgbill_cmel", precision: 15, scale: 6
    t.decimal "sfgbill_cmed", precision: 15, scale: 6
    t.decimal "sfgbill_cmet", precision: 15, scale: 6
    t.decimal "sfgbill_cawl", precision: 15, scale: 6
    t.decimal "sfgbill_cawd", precision: 15, scale: 6
    t.decimal "sfgbill_cawt", precision: 15, scale: 6
    t.decimal "sfgbill_cahl", precision: 15, scale: 6
    t.decimal "sfgbill_cahd", precision: 15, scale: 6
    t.decimal "sfgbill_caht", precision: 15, scale: 6
    t.decimal "sfgbill_cael", precision: 15, scale: 6
    t.decimal "sfgbill_caed", precision: 15, scale: 6
    t.decimal "sfgbill_caet", precision: 15, scale: 6
    t.string "cat", limit: 20
    t.string "cat_short", limit: 20
  end

  create_table "tb_sfgpl", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "sfgpl_year", comment: "년"
    t.integer "sfgpl_month", comment: "월"
    t.string "sfgpl_group", limit: 20, comment: "그룹"
    t.string "sfgpl_corp", limit: 20, comment: "법인"
    t.string "sfgpl_div", limit: 20, comment: "사업부"
    t.string "sfgpl_share", limit: 20, comment: "안분대상"
    t.string "sfgpl_exist", limit: 20, comment: "기존"
    t.string "shop_nm", limit: 20, comment: "업장"
    t.integer "s1000", comment: "매출액"
    t.integer "s1100", comment: "메인메뉴"
    t.integer "s1200", comment: "단품메뉴"
    t.integer "s1300", comment: "선물세트"
    t.integer "s1400", comment: "주류,음료매출"
    t.integer "s1500", comment: "기타"
    t.integer "s2000", comment: "총비용"
    t.integer "s2100", comment: "식재료비"
    t.integer "s2101", comment: "육류"
    t.integer "s2102", comment: "활어"
    t.integer "s2103", comment: "기타식재료"
    t.integer "s2104", comment: "주류,음료"
    t.integer "s2200", comment: "인건비"
    t.integer "s2201", comment: "급여"
    t.integer "s2202", comment: "잡급"
    t.integer "s2203", comment: "퇴직금"
    t.integer "s2204", comment: "4대보험"
    t.integer "s2205", comment: "주차대행료"
    t.integer "s2300", comment: "판관비"
    t.integer "s2301", comment: "가스료"
    t.integer "s2302", comment: "수도료"
    t.integer "s2303", comment: "전력비"
    t.integer "s2304", comment: "난방비"
    t.integer "s2305", comment: "세금과공과"
    t.integer "s2306", comment: "건물임차료"
    t.integer "s2307", comment: "건물관리비"
    t.integer "s2308", comment: "수선비"
    t.integer "s2309", comment: "소모품비"
    t.integer "s2310", comment: "보험료"
    t.integer "s2311", comment: "불판세척비"
    t.integer "s2312", comment: "음식물처리비"
    t.integer "s2313", comment: "지급수수료"
    t.integer "s2314", comment: "카드매출수수료"
    t.integer "s2315", comment: "광고선전비"
    t.integer "s2316", comment: "기타경비"
    t.integer "s2400", comment: "부가가치세"
    t.integer "s3000", comment: "영업이익"
    t.integer "s4100", comment: "영업외수익"
    t.integer "s4200", comment: "영업외비용"
    t.integer "s6000", comment: "세전이익"
    t.integer "s7000", comment: "법인,소득세"
    t.integer "s8000", comment: "당기순이익"
    t.integer "s9000", comment: "공시순이익"
    t.datetime "sfgpl_dt", comment: "마감날짜"
    t.string "shop_id", limit: 20, comment: "업장 아이디"
    t.integer "s4000", comment: "영업외손익"
  end

  create_table "tb_sfgretrv", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "shop_id", limit: 20
    t.string "sfgretrv_menu", limit: 20
    t.string "shop_nm", limit: 20
    t.datetime "sfgretrv_dt"
    t.decimal "sfgretrv_out", precision: 10, scale: 4
    t.decimal "sfgretrv_in", precision: 10, scale: 4
    t.string "sfgretrv_unit", limit: 10
  end

  create_table "tb_sfgscosta", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "costa_no"
    t.datetime "costa_dt"
    t.string "shop_id", limit: 20
    t.string "shop_nm", limit: 20
    t.decimal "costa_cat1cost", precision: 15, scale: 5
    t.decimal "costa_cat1sales", precision: 15, scale: 5
    t.decimal "costa_cat1rate", precision: 15, scale: 5
    t.decimal "costa_cat2cost", precision: 15, scale: 5
    t.decimal "costa_cat2sales", precision: 15, scale: 5
    t.decimal "costa_cat2rate", precision: 15, scale: 5
    t.decimal "costa_cat3cost", precision: 15, scale: 5
    t.decimal "costa_cat3sales", precision: 15, scale: 5
    t.decimal "costa_cat3rate", precision: 15, scale: 5
    t.decimal "costa_cat4rate", precision: 15, scale: 5
    t.decimal "costa_rate1", precision: 15, scale: 5
    t.decimal "costa_rate2", precision: 15, scale: 5
    t.decimal "costa_ratediff", precision: 15, scale: 5
  end

  create_table "tb_sfgshwng", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "shwng_ref", limit: 20
    t.string "shop_id", limit: 20
    t.string "shop_nm", limit: 20
    t.date "shwng_begin"
    t.date "shop_open"
    t.integer "shop_size"
    t.integer "shop_seats"
    t.integer "shwng_salesperseat"
    t.integer "shwng_sales"
    t.integer "shwng_salesprevy"
    t.integer "shwng_salesprevm"
    t.decimal "shwng_salesrateprevy", precision: 7, scale: 2
    t.decimal "shwng_salesrateprevm", precision: 7, scale: 2
    t.decimal "shwng_prate", precision: 7, scale: 2
    t.decimal "shwng_lrate", precision: 7, scale: 2
    t.integer "shwng_bills"
    t.integer "shwng_billpay"
    t.integer "shwng_l"
    t.integer "shwng_lprevm"
    t.integer "shwng_lprevy"
    t.integer "shwng_nu"
    t.datetime "shwng_end"
    t.integer "shwng_days"
    t.string "b_nm", limit: 100
    t.integer "shwng_salessclar"
  end

  create_table "tb_so_detail", primary_key: ["h_id", "s_id", "shop_id", "so_dt", "so_no", "sog_no"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "h_id", limit: 10, null: false
    t.string "s_id", limit: 10, null: false
    t.string "shop_id", limit: 10, null: false
    t.datetime "so_dt", null: false
    t.integer "so_no", limit: 2, null: false
    t.integer "sog_no", limit: 2, null: false
    t.string "b_id", limit: 10
    t.string "shop_nm", limit: 50
    t.integer "shop_sort", limit: 2
    t.string "gd_id", limit: 10
    t.string "sog_jc_st", limit: 1
    t.string "unit_id", limit: 20
    t.string "unit_nm", limit: 100
    t.decimal "sog_qty", precision: 10, scale: 2
    t.decimal "sog_uc", precision: 12, scale: 2
    t.decimal "sog_amt", precision: 12, scale: 2
    t.decimal "sog_real_amt", precision: 12, scale: 2
    t.decimal "sog_vos_amt", precision: 12, scale: 2
    t.decimal "sog_tax_amt", precision: 12, scale: 2
    t.decimal "sog_taxf_amt", precision: 12, scale: 2
    t.decimal "sog_ccl_amt", precision: 12, scale: 2
    t.string "sog_tax_st", limit: 1
    t.decimal "sog_odr_qty", precision: 10, scale: 2
    t.decimal "sog_rcv_qty", precision: 10, scale: 2
    t.decimal "sog_si_qty", precision: 10, scale: 2
    t.string "trd_id", limit: 10
    t.string "trd_nm", limit: 50
    t.string "gd_nm", limit: 100
    t.string "live_yn", limit: 1
    t.string "memo", limit: 200
    t.string "info", limit: 200
    t.integer "sort_no", limit: 2
    t.string "cret_usrid", limit: 20
    t.datetime "cret_dt"
    t.string "mod_usrid", limit: 20
    t.datetime "mod_dt"
    t.string "gdmr_id", limit: 10
    t.string "gdmj_id", limit: 50
    t.string "gdmr_nm", limit: 50
    t.string "gdmj_nm", limit: 50
  end

  add_foreign_key "attachfiles", "reportrooms", column: "reportid", name: "id"
end
