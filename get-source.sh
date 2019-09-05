#!/usr/bin/env bash

# Port of wikidumps.xml

# CONFIG BEGIN

lang='en'
dd='20190701'
dbpedia='3.9'
targetdir='repository/en/source'

# CONFIG END

if [ ! -d "$targetdir" ]; then
	mkdir -p "$targetdir"
fi

prefix="${lang}wiki-${dd}-"
pre_target="${lang}wiki-latest-"
baseurl="https://dumps.wikimedia.org/${lang}wiki/${dd}/"

md5="md5sums.txt"
ns0_titles="all-titles-in-ns0.gz"
abstract="abstract.xml"
page="page.sql.gz"
redirect="redirect.sql.gz"
pagelinks="pagelinks.sql.gz"
cat="category.sql.gz"
catlinks="categorylinks.sql.gz"
article="pages-articles.xml.bz2"

bdpedia_cat="http://downloads.dbpedia.org/${dbpedia}/${lang}/article_categories_${lang}.ttl.bz2"

get_gz_del () {
	file="$1"
	curl "${baseurl}${prefix}${file}" -o "${targetdir}/${pre_target}${file}"
	gunzip "${targetdir}/${pre_target}${file}"
	rm "${targetdir}/${pre_target}${file}"
}

# get-md5
curl "${baseurl}${prefix}${md5}" -o "${targetdir}/${pre_target}${md5}"

# get-ns0-titles
get_gz_del "${ns0_titles}"

# get-page
get_gz_del "${page}"

# get-redirect
get_gz_del "${redirect}"

# get-pagelinks
get_gz_del "${pagelinks}"

# get-cat
get_gz_del "${cat}"

# get-catlinks
get_gz_del "${catlinks}"

# get-abstract
curl "${baseurl}${prefix}${abstract}" -o "${targetdir}/${pre_target}${abstract}"

# get-article
curl "${baseurl}${prefix}${article}" -o "${targetdir}/${pre_target}${article}"
bunzip2 "${targetdir}/${pre_target}${article}"
rm "${targetdir}/${pre_target}${article}"

# get-dbpedia-cat
curl "${dbpedia_cat}" -o "${targetdir}/${lang}article_categories.ttl.bz2"
bunzip2 "${targetdir}/${lang}article_categories.ttl.bz2"
rm "${targetdir}/${lang}article_categories.ttl.bz2"

