module I18n
  class Config
    COMMON_PLURAL_RULES = {
      default: {
        keys: [:one, :other],
        rule: ->(n : Int32) { n == 1 ? :one : :other },
      },
      one_two_other: {
        keys: [:one, :two, :other],
        rule: ->(n : Int32) { n == 1 ? :one : n == 2 ? :two : :other },
      },
      other_only: {
        keys: [:other],
        rule: ->(n : Int32) { :other },
      },
    }

    DEFAULT_PLURAL_RULES = {
      "af" => COMMON_PLURAL_RULES[:default],
      "am" => COMMON_PLURAL_RULES[:default],
      "ar" => {
        keys: [:zero, :one, :two, :few, :many, :other],
        rule: ->(n : Int32) { n == 0 ? :zero : n == 1 ? :one : n == 2 ? :two : [3, 4, 5, 6, 7, 8, 9, 10].includes?(n % 100) ? :few : [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99].includes?(n % 100) ? :many : :other },
      },
      "az" => COMMON_PLURAL_RULES[:other_only],
      "be" => {
        keys: [:one, :few, :many, :other],
        rule: ->(n : Int32) { n % 10 == 1 && n % 100 != 11 ? :one : [2, 3, 4].includes?(n % 10) && ![12, 13, 14].includes?(n % 100) ? :few : n % 10 == 0 || [5, 6, 7, 8, 9].includes?(n % 10) || [11, 12, 13, 14].includes?(n % 100) ? :many : :other },
      },
      "bg" => COMMON_PLURAL_RULES[:default],
      "bh" => COMMON_PLURAL_RULES[:default],
      "bn" => COMMON_PLURAL_RULES[:default],
      "bo" => COMMON_PLURAL_RULES[:other_only],
      "bs" => {
        keys: [:one, :few, :many, :other],
        rule: ->(n : Int32) { n % 10 == 1 && n % 100 != 11 ? :one : [2, 3, 4].includes?(n % 10) && ![12, 13, 14].includes?(n % 100) ? :few : n % 10 == 0 || [5, 6, 7, 8, 9].includes?(n % 10) || [11, 12, 13, 14].includes?(n % 100) ? :many : :other },
      },
      "ca" => COMMON_PLURAL_RULES[:default],
      "cs" => {
        keys: [:one, :few, :other],
        rule: ->(n : Int32) { n == 1 ? :one : [2, 3, 4].includes?(n) ? :few : :other },
      },
      "cy" => {
        keys: [:one, :two, :many, :other],
        rule: ->(n : Int32) { n == 1 ? :one : n == 2 ? :two : n == 8 || n == 11 ? :many : :other },
      },
      "da"  => COMMON_PLURAL_RULES[:default],
      "de"  => COMMON_PLURAL_RULES[:default],
      "dz"  => COMMON_PLURAL_RULES[:other_only],
      "el"  => COMMON_PLURAL_RULES[:default],
      "en"  => COMMON_PLURAL_RULES[:default],
      "eo"  => COMMON_PLURAL_RULES[:default],
      "es"  => COMMON_PLURAL_RULES[:default],
      "et"  => COMMON_PLURAL_RULES[:default],
      "eu"  => COMMON_PLURAL_RULES[:default],
      "fa"  => COMMON_PLURAL_RULES[:other_only],
      "fi"  => COMMON_PLURAL_RULES[:default],
      "fil" => COMMON_PLURAL_RULES[:default],
      "fo"  => COMMON_PLURAL_RULES[:default],
      "fr"  => COMMON_PLURAL_RULES[:default],
      "fur" => COMMON_PLURAL_RULES[:default],
      "fy"  => COMMON_PLURAL_RULES[:default],
      "ga"  => COMMON_PLURAL_RULES[:one_two_other],
      "gl"  => COMMON_PLURAL_RULES[:default],
      "gu"  => COMMON_PLURAL_RULES[:default],
      "guw" => COMMON_PLURAL_RULES[:default],
      "ha"  => COMMON_PLURAL_RULES[:default],
      "he"  => COMMON_PLURAL_RULES[:default],
      "hi"  => COMMON_PLURAL_RULES[:default],
      "hr"  => {
        keys: [:one, :few, :many, :other],
        rule: ->(n : Int32) { n % 10 == 1 && n % 100 != 11 ? :one : [2, 3, 4].includes?(n % 10) && ![12, 13, 14].includes?(n % 100) ? :few : n % 10 == 0 || [5, 6, 7, 8, 9].includes?(n % 10) || [11, 12, 13, 14].includes?(n % 100) ? :many : :other },
      },
      "hu" => COMMON_PLURAL_RULES[:other_only],
      "id" => COMMON_PLURAL_RULES[:other_only],
      "is" => COMMON_PLURAL_RULES[:default],
      "it" => COMMON_PLURAL_RULES[:default],
      "iw" => COMMON_PLURAL_RULES[:default],
      "ja" => COMMON_PLURAL_RULES[:other_only],
      "jv" => COMMON_PLURAL_RULES[:other_only],
      "ka" => COMMON_PLURAL_RULES[:other_only],
      "km" => COMMON_PLURAL_RULES[:other_only],
      "kn" => COMMON_PLURAL_RULES[:other_only],
      "ko" => COMMON_PLURAL_RULES[:other_only],
      "ku" => COMMON_PLURAL_RULES[:default],
      "lb" => COMMON_PLURAL_RULES[:default],
      "ln" => COMMON_PLURAL_RULES[:default],
      "lt" => {
        keys: [:one, :few, :other],
        rule: ->(n : Int32) { n % 10 == 1 && ![11, 12, 13, 14, 15, 16, 17, 18, 19].includes?(n % 100) ? :one : [2, 3, 4, 5, 6, 7, 8, 9].includes?(n % 10) && ![11, 12, 13, 14, 15, 16, 17, 18, 19].includes?(n % 100) ? :few : :other },
      },
      "lv" => {
        keys: [:zero, :one, :other],
        rule: ->(n : Int32) { n == 0 ? :zero : n % 10 == 1 && n % 100 != 11 ? :one : :other },
      },
      "mg" => COMMON_PLURAL_RULES[:default],
      "mk" => {
        keys: [:one, :other],
        rule: ->(n : Int32) { n % 10 == 1 ? :one : :other },
      },
      "ml" => COMMON_PLURAL_RULES[:default],
      "mn" => COMMON_PLURAL_RULES[:default],
      "mo" => {
        keys: [:one, :few, :other],
        rule: ->(n : Int32) { n == 1 ? :one : :other },
      },
      "mr" => COMMON_PLURAL_RULES[:default],
      "ms" => COMMON_PLURAL_RULES[:other_only],
      "mt" => {
        keys: [:one, :few, :many, :other],
        rule: ->(n : Int32) { n == 1 ? :one : [2, 3, 4, 5, 6, 7, 8, 9, 10].includes?(n % 100) ? :few : [11, 12, 13, 14, 15, 16, 17, 18, 19].includes?(n % 100) ? :many : :other },
      },
      "my"  => COMMON_PLURAL_RULES[:other_only],
      "nah" => COMMON_PLURAL_RULES[:default],
      "nb"  => COMMON_PLURAL_RULES[:default],
      "ne"  => COMMON_PLURAL_RULES[:default],
      "nl"  => COMMON_PLURAL_RULES[:default],
      "nn"  => COMMON_PLURAL_RULES[:default],
      "no"  => COMMON_PLURAL_RULES[:default],
      "nso" => COMMON_PLURAL_RULES[:default],
      "oc"  => COMMON_PLURAL_RULES[:default],
      "om"  => COMMON_PLURAL_RULES[:default],
      "or"  => COMMON_PLURAL_RULES[:default],
      "pa"  => COMMON_PLURAL_RULES[:default],
      "pap" => COMMON_PLURAL_RULES[:default],
      "pl"  => {
        keys: [:one, :few, :many, :other],
        rule: ->(n : Int32) { n == 1 ? :one : [2, 3, 4].includes?(n % 10) && ![12, 13, 14].includes?(n % 100) ? :few : (n != 1 && [0, 1].includes?(n % 10)) || [5, 6, 7, 8, 9].includes?(n % 10) || [12, 13, 14].includes?(n % 100) ? :many : :other },
      },
      "ps"    => COMMON_PLURAL_RULES[:default],
      "pt"    => COMMON_PLURAL_RULES[:default],
      "pt-PT" => COMMON_PLURAL_RULES[:default],
      "ro"    => {
        keys: [:one, :other],
        rule: ->(n : Int32) { n == 1 ? :one : :other },
      },
      "ru" => {
        keys: [:one, :few, :many, :other],
        rule: ->(n : Int32) { n % 10 == 1 && n % 100 != 11 ? :one : [2, 3, 4].includes?(n % 10) && ![12, 13, 14].includes?(n % 100) ? :few : n % 10 == 0 || [5, 6, 7, 8, 9].includes?(n % 10) || [11, 12, 13, 14].includes?(n % 100) ? :many : :other },
      },
      "se" => COMMON_PLURAL_RULES[:one_two_other],
      "sh" => {
        keys: [:one, :few, :many, :other],
        rule: ->(n : Int32) { n % 10 == 1 && n % 100 != 11 ? :one : [2, 3, 4].includes?(n % 10) && ![12, 13, 14].includes?(n % 100) ? :few : n % 10 == 0 || [5, 6, 7, 8, 9].includes?(n % 10) || [11, 12, 13, 14].includes?(n % 100) ? :many : :other },
      },
      "sk" => {
        keys: [:one, :few, :other],
        rule: ->(n : Int32) { n == 1 ? :one : [2, 3, 4].includes?(n) ? :few : :other },
      },
      "sl" => {
        keys: [:one, :two, :few, :other],
        rule: ->(n : Int32) { n % 100 == 1 ? :one : n % 100 == 2 ? :two : [3, 4].includes?(n % 100) ? :few : :other },
      },
      "sma" => COMMON_PLURAL_RULES[:one_two_other],
      "smi" => COMMON_PLURAL_RULES[:one_two_other],
      "smj" => COMMON_PLURAL_RULES[:one_two_other],
      "smn" => COMMON_PLURAL_RULES[:one_two_other],
      "sms" => COMMON_PLURAL_RULES[:one_two_other],
      "so"  => COMMON_PLURAL_RULES[:default],
      "sq"  => COMMON_PLURAL_RULES[:default],
      "sr"  => {
        keys: [:one, :few, :many, :other],
        rule: ->(n : Int32) { n % 10 == 1 && n % 100 != 11 ? :one : [2, 3, 4].includes?(n % 10) && ![12, 13, 14].includes?(n % 100) ? :few : n % 10 == 0 || [5, 6, 7, 8, 9].includes?(n % 10) || [11, 12, 13, 14].includes?(n % 100) ? :many : :other },
      },
      "sv" => COMMON_PLURAL_RULES[:default],
      "sw" => COMMON_PLURAL_RULES[:default],
      "ta" => COMMON_PLURAL_RULES[:default],
      "te" => COMMON_PLURAL_RULES[:default],
      "th" => COMMON_PLURAL_RULES[:other_only],
      "ti" => COMMON_PLURAL_RULES[:default],
      "tk" => COMMON_PLURAL_RULES[:default],
      "tl" => COMMON_PLURAL_RULES[:default],
      "to" => COMMON_PLURAL_RULES[:other_only],
      "tr" => COMMON_PLURAL_RULES[:other_only],
      "uk" => {
        keys: [:one, :few, :many, :other],
        rule: ->(n : Int32) { n % 10 == 1 && n % 100 != 11 ? :one : [2, 3, 4].includes?(n % 10) && ![12, 13, 14].includes?(n % 100) ? :few : n % 10 == 0 || [5, 6, 7, 8, 9].includes?(n % 10) || [11, 12, 13, 14].includes?(n % 100) ? :many : :other },
      },
      "ur" => COMMON_PLURAL_RULES[:default],
      "vi" => COMMON_PLURAL_RULES[:other_only],
      "wa" => COMMON_PLURAL_RULES[:default],
      "yo" => COMMON_PLURAL_RULES[:other_only],
      "zh" => COMMON_PLURAL_RULES[:other_only],
      "zu" => COMMON_PLURAL_RULES[:default],
    }
  end
end
