#!/usr/bin/env rails runner

WholesalerForelle.all.each &:extract

Stream.write "----- Mapping ----------------------------"

Stream.write WholesalerVariant.where(:variant_id => nil).all.map(&:set_variant_id).compact.size
