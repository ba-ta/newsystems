#! ruby -Ku
#
# クローラクラス(for 三善機械)のソースファイル
# Author::    川端洋平
# Date::      2013/01/20
# Copyright:: Copyright (c) 2013 川端洋平
#
require File.dirname(__FILE__) + '/base'
require 'csv'

# クローラクラス
class Yuushi < Base
  #
  # コンストラクタ
  # Param:  Hash site クロール対象サイト情報
  #
  def initialize()
    # 親クラスのコンストラクタ
    super()

    @company    = '株式会社ユウシ'
    @company_id = 25
    @start_uri  = 'http://www.chuuko-kikai.com/item-list.php'

    @crawl_allow = /xxxxx/
    @crawl_deny  = //
  end

  #
  # スクレイピング処理
  # Return:: self
  #
  def scrape
    #### ページ情報のスクレイピング ####
    @p.search('a[href*="blog_id1"]').each do |m|
      #### ディープクロール ####
      detail_uri = join_uri(@p.uri, m[:href])
      begin
        p2 = nokogiri(detail_uri)

        uid = p2.at(".item-detail-table table:nth(1) td:nth(1)").text.f
        next unless check_uid(uid)

        temp = {
          uid:       uid,
          no:        uid,
          name:      p2.at(".item-detail-table table:nth(1) tr:nth(2) td").text.f,
          maker:     p2.at(".item-detail-table table:nth(1) tr:nth(3) td").text.f,
          model:     p2.at(".item-detail-table table:nth(1) tr:nth(4) td").text.f,
          year:      p2.at(".item-detail-table table:nth(1) tr:nth(5) td").text.f,
          spec:      p2.at(".item-detail-table table:nth(2) tr:nth(1) td").text.f,
          accessory: p2.at(".item-detail-table table:nth(2) tr:nth(2) td").text.f,
          comment:   p2.at(".item-detail-table table:nth(2) tr:nth(3) td").text.f,
          location:  "本社",
          hint:      p2.at(".item-detail-table table:nth(1) tr:nth(2) td").text.f,
        }

        next if temp[:maker] =~ /●/

        # 画像
        temp[:used_imgs] = []
        p2.search('.img-sub img').each do |i|
          next unless /(jpg|JPG|jpeg|JPEG)$/ =~ i[:src]
          next if     /image_noimage/ =~ i[:src]
          temp[:used_imgs] << join_uri(detail_uri, i[:src])
        end

        @d << temp if temp[:name]
        @log.debug(temp)
      rescue => exc
        error_report("scrape error (#{uid || 0})", exc)
        next
      end
    end

    return self
  end
end
