import Schism

schism "variables and atoms" do
  dogma "split" do
    # Generated from lib/makeup/lexers/elixir_lexer/variables_start.ex.exs, do not edit.
    # Generated at 2020-10-02 11:22:44Z.

    defmodule Makeup.Lexers.ElixirLexer.VariablesStart do
      @moduledoc false

      def variable_start_chars__0(
            <<x0::utf8, rest::binary>>,
            acc,
            stack,
            context,
            comb__line,
            comb__offset
          )
          when x0 === 95 or (x0 >= 97 and x0 <= 122) or x0 === 170 or x0 === 181 or x0 === 186 or
                 (x0 >= 223 and x0 <= 246) or (x0 >= 248 and x0 <= 255) or x0 === 257 or
                 x0 === 259 or
                 x0 === 261 or x0 === 263 or x0 === 265 or x0 === 267 or x0 === 269 or x0 === 271 or
                 x0 === 273 or x0 === 275 or x0 === 277 or x0 === 279 or x0 === 281 or x0 === 283 or
                 x0 === 285 or x0 === 287 or x0 === 289 or x0 === 291 or x0 === 293 or x0 === 295 or
                 x0 === 297 or x0 === 299 or x0 === 301 or x0 === 303 or x0 === 305 or x0 === 307 or
                 x0 === 309 or (x0 >= 311 and x0 <= 312) or x0 === 314 or x0 === 316 or x0 === 318 or
                 x0 === 320 or x0 === 322 or x0 === 324 or x0 === 326 or (x0 >= 328 and x0 <= 329) or
                 x0 === 331 or x0 === 333 or x0 === 335 or x0 === 337 or x0 === 339 or x0 === 341 or
                 x0 === 343 or x0 === 345 or x0 === 347 or x0 === 349 or x0 === 351 or x0 === 353 or
                 x0 === 355 or x0 === 357 or x0 === 359 or x0 === 361 or x0 === 363 or x0 === 365 or
                 x0 === 367 or x0 === 369 or x0 === 371 or x0 === 373 or x0 === 375 or x0 === 378 or
                 x0 === 380 or (x0 >= 382 and x0 <= 384) or x0 === 387 or x0 === 389 or x0 === 392 or
                 (x0 >= 396 and x0 <= 397) or x0 === 402 or x0 === 405 or
                 (x0 >= 409 and x0 <= 411) or
                 x0 === 414 or x0 === 417 or x0 === 419 or x0 === 421 or x0 === 424 or
                 (x0 >= 426 and x0 <= 427) or x0 === 429 or x0 === 432 or x0 === 436 or x0 === 438 or
                 (x0 >= 441 and x0 <= 443) or (x0 >= 445 and x0 <= 451) or x0 === 454 or
                 x0 === 457 or
                 x0 === 460 or x0 === 462 or x0 === 464 or x0 === 466 or x0 === 468 or x0 === 470 or
                 x0 === 472 or x0 === 474 or (x0 >= 476 and x0 <= 477) or x0 === 479 or x0 === 481 or
                 x0 === 483 or x0 === 485 or x0 === 487 or x0 === 489 or x0 === 491 or x0 === 493 or
                 (x0 >= 495 and x0 <= 496) or x0 === 499 or x0 === 501 or x0 === 505 or x0 === 507 or
                 x0 === 509 or x0 === 511 or x0 === 513 or x0 === 515 or x0 === 517 or x0 === 519 or
                 x0 === 521 or x0 === 523 or x0 === 525 or x0 === 527 or x0 === 529 or x0 === 531 or
                 x0 === 533 or x0 === 535 or x0 === 537 or x0 === 539 or x0 === 541 or x0 === 543 or
                 x0 === 545 or x0 === 547 or x0 === 549 or x0 === 551 or x0 === 553 or x0 === 555 or
                 x0 === 557 or x0 === 559 or x0 === 561 or (x0 >= 563 and x0 <= 569) or x0 === 572 or
                 (x0 >= 575 and x0 <= 576) or x0 === 578 or x0 === 583 or x0 === 585 or x0 === 587 or
                 x0 === 589 or (x0 >= 591 and x0 <= 705) or (x0 >= 710 and x0 <= 721) or
                 (x0 >= 736 and x0 <= 740) or x0 === 748 or x0 === 750 or
                 (x0 >= 881 and x0 <= 884) or
                 x0 === 887 or (x0 >= 890 and x0 <= 893) or (x0 >= 912 and x0 <= 929) or
                 (x0 >= 940 and x0 <= 1013) or (x0 >= 1016 and x0 <= 1153) or
                 (x0 >= 1163 and x0 <= 1327) or x0 === 1369 or (x0 >= 1376 and x0 <= 1416) or
                 (x0 >= 1488 and x0 <= 1514) or (x0 >= 1519 and x0 <= 1522) or
                 (x0 >= 1568 and x0 <= 1610) or (x0 >= 1646 and x0 <= 1647) or
                 (x0 >= 1649 and x0 <= 1747) or x0 === 1749 or (x0 >= 1765 and x0 <= 1766) or
                 (x0 >= 1774 and x0 <= 1775) or (x0 >= 1786 and x0 <= 1788) or x0 === 1791 or
                 x0 === 1808 or (x0 >= 1810 and x0 <= 1839) or (x0 >= 1869 and x0 <= 1957) or
                 x0 === 1969 or (x0 >= 1994 and x0 <= 2026) or (x0 >= 2036 and x0 <= 2037) or
                 x0 === 2042 or (x0 >= 2048 and x0 <= 2069) or x0 === 2074 or x0 === 2084 or
                 x0 === 2088 or (x0 >= 2112 and x0 <= 2136) or (x0 >= 2144 and x0 <= 2154) or
                 (x0 >= 2208 and x0 <= 2228) or (x0 >= 2230 and x0 <= 2247) or
                 (x0 >= 2308 and x0 <= 2361) or x0 === 2365 or x0 === 2384 or
                 (x0 >= 2392 and x0 <= 2401) or (x0 >= 2417 and x0 <= 2432) or
                 (x0 >= 2437 and x0 <= 2444) or (x0 >= 2447 and x0 <= 2448) or
                 (x0 >= 2451 and x0 <= 2472) or (x0 >= 2474 and x0 <= 2480) or x0 === 2482 or
                 (x0 >= 2486 and x0 <= 2489) or x0 === 2493 or x0 === 2510 or
                 (x0 >= 2524 and x0 <= 2525) or (x0 >= 2527 and x0 <= 2529) or
                 (x0 >= 2544 and x0 <= 2545) or x0 === 2556 or (x0 >= 2565 and x0 <= 2570) or
                 (x0 >= 2575 and x0 <= 2576) or (x0 >= 2579 and x0 <= 2600) or
                 (x0 >= 2602 and x0 <= 2608) or (x0 >= 2610 and x0 <= 2611) or
                 (x0 >= 2613 and x0 <= 2614) or (x0 >= 2616 and x0 <= 2617) or
                 (x0 >= 2649 and x0 <= 2652) or x0 === 2654 or (x0 >= 2674 and x0 <= 2676) or
                 (x0 >= 2693 and x0 <= 2701) or (x0 >= 2703 and x0 <= 2705) or
                 (x0 >= 2707 and x0 <= 2728) or (x0 >= 2730 and x0 <= 2736) or
                 (x0 >= 2738 and x0 <= 2739) or (x0 >= 2741 and x0 <= 2745) or x0 === 2749 or
                 x0 === 2768 or (x0 >= 2784 and x0 <= 2785) or x0 === 2809 or
                 (x0 >= 2821 and x0 <= 2828) or (x0 >= 2831 and x0 <= 2832) or
                 (x0 >= 2835 and x0 <= 2856) or (x0 >= 2858 and x0 <= 2864) or
                 (x0 >= 2866 and x0 <= 2867) or (x0 >= 2869 and x0 <= 2873) or x0 === 2877 or
                 (x0 >= 2908 and x0 <= 2909) or (x0 >= 2911 and x0 <= 2913) or x0 === 2929 or
                 x0 === 2947 or (x0 >= 2949 and x0 <= 2954) or (x0 >= 2958 and x0 <= 2960) or
                 (x0 >= 2962 and x0 <= 2965) or (x0 >= 2969 and x0 <= 2970) or x0 === 2972 or
                 (x0 >= 2974 and x0 <= 2975) or (x0 >= 2979 and x0 <= 2980) or
                 (x0 >= 2984 and x0 <= 2986) or (x0 >= 2990 and x0 <= 3001) or x0 === 3024 or
                 (x0 >= 3077 and x0 <= 3084) or (x0 >= 3086 and x0 <= 3088) or
                 (x0 >= 3090 and x0 <= 3112) or (x0 >= 3114 and x0 <= 3129) or x0 === 3133 or
                 (x0 >= 3160 and x0 <= 3162) or (x0 >= 3168 and x0 <= 3169) or x0 === 3200 or
                 (x0 >= 3205 and x0 <= 3212) or (x0 >= 3214 and x0 <= 3216) or
                 (x0 >= 3218 and x0 <= 3240) or (x0 >= 3242 and x0 <= 3251) or
                 (x0 >= 3253 and x0 <= 3257) or x0 === 3261 or x0 === 3294 or
                 (x0 >= 3296 and x0 <= 3297) or (x0 >= 3313 and x0 <= 3314) or
                 (x0 >= 3332 and x0 <= 3340) or (x0 >= 3342 and x0 <= 3344) or
                 (x0 >= 3346 and x0 <= 3386) or x0 === 3389 or x0 === 3406 or
                 (x0 >= 3412 and x0 <= 3414) or (x0 >= 3423 and x0 <= 3425) or
                 (x0 >= 3450 and x0 <= 3455) or (x0 >= 3461 and x0 <= 3478) or
                 (x0 >= 3482 and x0 <= 3505) or (x0 >= 3507 and x0 <= 3515) or x0 === 3517 or
                 (x0 >= 3520 and x0 <= 3526) or (x0 >= 3585 and x0 <= 3632) or
                 (x0 >= 3634 and x0 <= 3635) or (x0 >= 3648 and x0 <= 3654) or
                 (x0 >= 3713 and x0 <= 3714) or x0 === 3716 or (x0 >= 3718 and x0 <= 3722) or
                 (x0 >= 3724 and x0 <= 3747) or x0 === 3749 or (x0 >= 3751 and x0 <= 3760) or
                 (x0 >= 3762 and x0 <= 3763) or x0 === 3773 or (x0 >= 3776 and x0 <= 3780) or
                 x0 === 3782 or (x0 >= 3804 and x0 <= 3807) or x0 === 3840 or
                 (x0 >= 3904 and x0 <= 3911) or (x0 >= 3913 and x0 <= 3948) or
                 (x0 >= 3976 and x0 <= 3980) or (x0 >= 4096 and x0 <= 4138) or x0 === 4159 or
                 (x0 >= 4176 and x0 <= 4181) or (x0 >= 4186 and x0 <= 4189) or x0 === 4193 or
                 (x0 >= 4197 and x0 <= 4198) or (x0 >= 4206 and x0 <= 4208) or
                 (x0 >= 4213 and x0 <= 4225) or x0 === 4238 or (x0 >= 4304 and x0 <= 4346) or
                 (x0 >= 4348 and x0 <= 4680) or (x0 >= 4682 and x0 <= 4685) or
                 (x0 >= 4688 and x0 <= 4694) or x0 === 4696 or (x0 >= 4698 and x0 <= 4701) or
                 (x0 >= 4704 and x0 <= 4744) or (x0 >= 4746 and x0 <= 4749) or
                 (x0 >= 4752 and x0 <= 4784) or (x0 >= 4786 and x0 <= 4789) or
                 (x0 >= 4792 and x0 <= 4798) or x0 === 4800 or (x0 >= 4802 and x0 <= 4805) or
                 (x0 >= 4808 and x0 <= 4822) or (x0 >= 4824 and x0 <= 4880) or
                 (x0 >= 4882 and x0 <= 4885) or (x0 >= 4888 and x0 <= 4954) or
                 (x0 >= 4992 and x0 <= 5007) or (x0 >= 5112 and x0 <= 5117) or
                 (x0 >= 5121 and x0 <= 5740) or (x0 >= 5743 and x0 <= 5759) or
                 (x0 >= 5761 and x0 <= 5786) or (x0 >= 5792 and x0 <= 5866) or
                 (x0 >= 5870 and x0 <= 5880) or (x0 >= 5888 and x0 <= 5900) or
                 (x0 >= 5902 and x0 <= 5905) or (x0 >= 5920 and x0 <= 5937) or
                 (x0 >= 5952 and x0 <= 5969) or (x0 >= 5984 and x0 <= 5996) or
                 (x0 >= 5998 and x0 <= 6000) or (x0 >= 6016 and x0 <= 6067) or x0 === 6103 or
                 x0 === 6108 or (x0 >= 6176 and x0 <= 6264) or (x0 >= 6272 and x0 <= 6312) or
                 x0 === 6314 or (x0 >= 6320 and x0 <= 6389) or (x0 >= 6400 and x0 <= 6430) or
                 (x0 >= 6480 and x0 <= 6509) or (x0 >= 6512 and x0 <= 6516) or
                 (x0 >= 6528 and x0 <= 6571) or (x0 >= 6576 and x0 <= 6601) or
                 (x0 >= 6656 and x0 <= 6678) or (x0 >= 6688 and x0 <= 6740) or x0 === 6823 or
                 (x0 >= 6917 and x0 <= 6963) or (x0 >= 6981 and x0 <= 6987) or
                 (x0 >= 7043 and x0 <= 7072) or (x0 >= 7086 and x0 <= 7087) or
                 (x0 >= 7098 and x0 <= 7141) or (x0 >= 7168 and x0 <= 7203) or
                 (x0 >= 7245 and x0 <= 7247) or (x0 >= 7258 and x0 <= 7293) or
                 (x0 >= 7296 and x0 <= 7304) or (x0 >= 7401 and x0 <= 7404) or
                 (x0 >= 7406 and x0 <= 7411) or (x0 >= 7413 and x0 <= 7414) or x0 === 7418 or
                 (x0 >= 7424 and x0 <= 7615) or (x0 >= 7681 and x0 <= 7957) or
                 (x0 >= 7968 and x0 <= 7975) or (x0 >= 7984 and x0 <= 7991) or
                 (x0 >= 8000 and x0 <= 8005) or (x0 >= 8016 and x0 <= 8023) or
                 (x0 >= 8032 and x0 <= 8061) or (x0 >= 8064 and x0 <= 8071) or
                 (x0 >= 8080 and x0 <= 8087) or (x0 >= 8096 and x0 <= 8103) or
                 (x0 >= 8112 and x0 <= 8116) or (x0 >= 8118 and x0 <= 8119) or x0 === 8126 or
                 (x0 >= 8130 and x0 <= 8132) or (x0 >= 8134 and x0 <= 8135) or
                 (x0 >= 8144 and x0 <= 8147) or (x0 >= 8150 and x0 <= 8151) or
                 (x0 >= 8160 and x0 <= 8167) or (x0 >= 8178 and x0 <= 8180) or
                 (x0 >= 8182 and x0 <= 8183) or x0 === 8305 or x0 === 8319 or
                 (x0 >= 8336 and x0 <= 8348) or x0 === 8458 or (x0 >= 8462 and x0 <= 8463) or
                 x0 === 8467 or x0 === 8472 or (x0 >= 8494 and x0 <= 8505) or
                 (x0 >= 8508 and x0 <= 8509) or (x0 >= 8518 and x0 <= 8521) or x0 === 8526 or
                 (x0 >= 8544 and x0 <= 8578) or (x0 >= 8580 and x0 <= 8584) or
                 (x0 >= 11312 and x0 <= 11358) or (x0 >= 11361 and x0 <= 11492) or
                 (x0 >= 11500 and x0 <= 11502) or x0 === 11507 or (x0 >= 11520 and x0 <= 11557) or
                 x0 === 11559 or x0 === 11565 or (x0 >= 11568 and x0 <= 11623) or x0 === 11631 or
                 (x0 >= 11648 and x0 <= 11670) or (x0 >= 11680 and x0 <= 11686) or
                 (x0 >= 11688 and x0 <= 11694) or (x0 >= 11696 and x0 <= 11702) or
                 (x0 >= 11704 and x0 <= 11710) or (x0 >= 11712 and x0 <= 11718) or
                 (x0 >= 11720 and x0 <= 11726) or (x0 >= 11728 and x0 <= 11734) or
                 (x0 >= 11736 and x0 <= 11742) or (x0 >= 12293 and x0 <= 12295) or
                 (x0 >= 12321 and x0 <= 12329) or (x0 >= 12337 and x0 <= 12341) or
                 (x0 >= 12344 and x0 <= 12348) or (x0 >= 12353 and x0 <= 12438) or
                 (x0 >= 12443 and x0 <= 12447) or (x0 >= 12449 and x0 <= 12538) or
                 (x0 >= 12540 and x0 <= 12543) or (x0 >= 12549 and x0 <= 12591) or
                 (x0 >= 12593 and x0 <= 12686) or (x0 >= 12704 and x0 <= 12735) or
                 (x0 >= 12784 and x0 <= 12799) or (x0 >= 13312 and x0 <= 19903) or
                 (x0 >= 19968 and x0 <= 40956) or (x0 >= 40960 and x0 <= 42124) or
                 (x0 >= 42192 and x0 <= 42237) or (x0 >= 42240 and x0 <= 42508) or
                 (x0 >= 42512 and x0 <= 42527) or (x0 >= 42538 and x0 <= 42539) or
                 (x0 >= 42561 and x0 <= 42606) or x0 === 42623 or x0 === 42625 or x0 === 42627 or
                 x0 === 42629 or x0 === 42631 or x0 === 42633 or x0 === 42635 or x0 === 42637 or
                 x0 === 42639 or x0 === 42641 or x0 === 42643 or x0 === 42645 or x0 === 42647 or
                 x0 === 42649 or (x0 >= 42651 and x0 <= 42653) or (x0 >= 42656 and x0 <= 42735) or
                 (x0 >= 42775 and x0 <= 42783) or (x0 >= 42787 and x0 <= 42888) or
                 (x0 >= 42892 and x0 <= 42943) or (x0 >= 42947 and x0 <= 42954) or
                 (x0 >= 42998 and x0 <= 43009) or (x0 >= 43011 and x0 <= 43013) or
                 (x0 >= 43015 and x0 <= 43018) or (x0 >= 43020 and x0 <= 43042) or
                 (x0 >= 43072 and x0 <= 43123) or (x0 >= 43138 and x0 <= 43187) or
                 (x0 >= 43250 and x0 <= 43255) or x0 === 43259 or (x0 >= 43261 and x0 <= 43262) or
                 (x0 >= 43274 and x0 <= 43301) or (x0 >= 43312 and x0 <= 43334) or
                 (x0 >= 43360 and x0 <= 43388) or (x0 >= 43396 and x0 <= 43442) or x0 === 43471 or
                 (x0 >= 43488 and x0 <= 43492) or (x0 >= 43494 and x0 <= 43503) or
                 (x0 >= 43514 and x0 <= 43518) or (x0 >= 43520 and x0 <= 43560) or
                 (x0 >= 43584 and x0 <= 43586) or (x0 >= 43588 and x0 <= 43595) or
                 (x0 >= 43616 and x0 <= 43638) or x0 === 43642 or (x0 >= 43646 and x0 <= 43695) or
                 x0 === 43697 or (x0 >= 43701 and x0 <= 43702) or (x0 >= 43705 and x0 <= 43709) or
                 x0 === 43712 or x0 === 43714 or (x0 >= 43739 and x0 <= 43741) or
                 (x0 >= 43744 and x0 <= 43754) or (x0 >= 43762 and x0 <= 43764) or
                 (x0 >= 43777 and x0 <= 43782) or (x0 >= 43785 and x0 <= 43790) or
                 (x0 >= 43793 and x0 <= 43798) or (x0 >= 43808 and x0 <= 43814) or
                 (x0 >= 43816 and x0 <= 43822) or (x0 >= 43824 and x0 <= 43866) or
                 (x0 >= 43868 and x0 <= 43881) or (x0 >= 43888 and x0 <= 44002) or
                 (x0 >= 44032 and x0 <= 55203) or (x0 >= 55216 and x0 <= 55238) or
                 (x0 >= 55243 and x0 <= 55291) or (x0 >= 63744 and x0 <= 64109) or
                 (x0 >= 64112 and x0 <= 64217) or (x0 >= 64256 and x0 <= 64262) or
                 (x0 >= 64275 and x0 <= 64279) or x0 === 64285 or (x0 >= 64287 and x0 <= 64296) or
                 (x0 >= 64298 and x0 <= 64310) or (x0 >= 64312 and x0 <= 64316) or x0 === 64318 or
                 (x0 >= 64320 and x0 <= 64321) or (x0 >= 64323 and x0 <= 64324) or
                 (x0 >= 64326 and x0 <= 64433) or (x0 >= 64467 and x0 <= 64829) or
                 (x0 >= 64848 and x0 <= 64911) or (x0 >= 64914 and x0 <= 64967) or
                 (x0 >= 65008 and x0 <= 65019) or (x0 >= 65136 and x0 <= 65140) or
                 (x0 >= 65142 and x0 <= 65276) or (x0 >= 65345 and x0 <= 65370) or
                 (x0 >= 65382 and x0 <= 65470) or (x0 >= 65474 and x0 <= 65479) or
                 (x0 >= 65482 and x0 <= 65487) or (x0 >= 65490 and x0 <= 65495) or
                 (x0 >= 65498 and x0 <= 65500) or (x0 >= 65536 and x0 <= 65547) or
                 (x0 >= 65549 and x0 <= 65574) or (x0 >= 65576 and x0 <= 65594) or
                 (x0 >= 65596 and x0 <= 65597) or (x0 >= 65599 and x0 <= 65613) or
                 (x0 >= 65616 and x0 <= 65629) or (x0 >= 65664 and x0 <= 65786) or
                 (x0 >= 65856 and x0 <= 65908) or (x0 >= 66176 and x0 <= 66204) or
                 (x0 >= 66208 and x0 <= 66256) or (x0 >= 66304 and x0 <= 66335) or
                 (x0 >= 66349 and x0 <= 66378) or (x0 >= 66384 and x0 <= 66421) or
                 (x0 >= 66432 and x0 <= 66461) or (x0 >= 66464 and x0 <= 66499) or
                 (x0 >= 66504 and x0 <= 66511) or (x0 >= 66513 and x0 <= 66517) or
                 (x0 >= 66600 and x0 <= 66717) or (x0 >= 66776 and x0 <= 66811) or
                 (x0 >= 66816 and x0 <= 66855) or (x0 >= 66864 and x0 <= 66915) or
                 (x0 >= 67072 and x0 <= 67382) or (x0 >= 67392 and x0 <= 67413) or
                 (x0 >= 67424 and x0 <= 67431) or (x0 >= 67584 and x0 <= 67589) or x0 === 67592 or
                 (x0 >= 67594 and x0 <= 67637) or (x0 >= 67639 and x0 <= 67640) or x0 === 67644 or
                 (x0 >= 67647 and x0 <= 67669) or (x0 >= 67680 and x0 <= 67702) or
                 (x0 >= 67712 and x0 <= 67742) or (x0 >= 67808 and x0 <= 67826) or
                 (x0 >= 67828 and x0 <= 67829) or (x0 >= 67840 and x0 <= 67861) or
                 (x0 >= 67872 and x0 <= 67897) or (x0 >= 67968 and x0 <= 68023) or
                 (x0 >= 68030 and x0 <= 68031) or x0 === 68096 or (x0 >= 68112 and x0 <= 68115) or
                 (x0 >= 68117 and x0 <= 68119) or (x0 >= 68121 and x0 <= 68149) or
                 (x0 >= 68192 and x0 <= 68220) or (x0 >= 68224 and x0 <= 68252) or
                 (x0 >= 68288 and x0 <= 68295) or (x0 >= 68297 and x0 <= 68324) or
                 (x0 >= 68352 and x0 <= 68405) or (x0 >= 68416 and x0 <= 68437) or
                 (x0 >= 68448 and x0 <= 68466) or (x0 >= 68480 and x0 <= 68497) or
                 (x0 >= 68608 and x0 <= 68680) or (x0 >= 68800 and x0 <= 68850) or
                 (x0 >= 68864 and x0 <= 68899) or (x0 >= 69248 and x0 <= 69289) or
                 (x0 >= 69296 and x0 <= 69297) or (x0 >= 69376 and x0 <= 69404) or x0 === 69415 or
                 (x0 >= 69424 and x0 <= 69445) or (x0 >= 69552 and x0 <= 69572) or
                 (x0 >= 69600 and x0 <= 69622) or (x0 >= 69635 and x0 <= 69687) or
                 (x0 >= 69763 and x0 <= 69807) or (x0 >= 69840 and x0 <= 69864) or
                 (x0 >= 69891 and x0 <= 69926) or x0 === 69956 or x0 === 69959 or
                 (x0 >= 69968 and x0 <= 70002) or x0 === 70006 or (x0 >= 70019 and x0 <= 70066) or
                 (x0 >= 70081 and x0 <= 70084) or x0 === 70106 or x0 === 70108 or
                 (x0 >= 70144 and x0 <= 70161) or (x0 >= 70163 and x0 <= 70187) or
                 (x0 >= 70272 and x0 <= 70278) or x0 === 70280 or (x0 >= 70282 and x0 <= 70285) or
                 (x0 >= 70287 and x0 <= 70301) or (x0 >= 70303 and x0 <= 70312) or
                 (x0 >= 70320 and x0 <= 70366) or (x0 >= 70405 and x0 <= 70412) or
                 (x0 >= 70415 and x0 <= 70416) or (x0 >= 70419 and x0 <= 70440) or
                 (x0 >= 70442 and x0 <= 70448) or (x0 >= 70450 and x0 <= 70451) or
                 (x0 >= 70453 and x0 <= 70457) or x0 === 70461 or x0 === 70480 or
                 (x0 >= 70493 and x0 <= 70497) or (x0 >= 70656 and x0 <= 70708) or
                 (x0 >= 70727 and x0 <= 70730) or (x0 >= 70751 and x0 <= 70753) or
                 (x0 >= 70784 and x0 <= 70831) or (x0 >= 70852 and x0 <= 70853) or x0 === 70855 or
                 (x0 >= 71040 and x0 <= 71086) or (x0 >= 71128 and x0 <= 71131) or
                 (x0 >= 71168 and x0 <= 71215) or x0 === 71236 or (x0 >= 71296 and x0 <= 71338) or
                 x0 === 71352 or (x0 >= 71424 and x0 <= 71450) or (x0 >= 71680 and x0 <= 71723) or
                 (x0 >= 71872 and x0 <= 71903) or (x0 >= 71935 and x0 <= 71942) or x0 === 71945 or
                 (x0 >= 71948 and x0 <= 71955) or (x0 >= 71957 and x0 <= 71958) or
                 (x0 >= 71960 and x0 <= 71983) or x0 === 71999 or x0 === 72001 or
                 (x0 >= 72096 and x0 <= 72103) or (x0 >= 72106 and x0 <= 72144) or x0 === 72161 or
                 x0 === 72163 or x0 === 72192 or (x0 >= 72203 and x0 <= 72242) or x0 === 72250 or
                 x0 === 72272 or (x0 >= 72284 and x0 <= 72329) or x0 === 72349 or
                 (x0 >= 72384 and x0 <= 72440) or (x0 >= 72704 and x0 <= 72712) or
                 (x0 >= 72714 and x0 <= 72750) or x0 === 72768 or (x0 >= 72818 and x0 <= 72847) or
                 (x0 >= 72960 and x0 <= 72966) or (x0 >= 72968 and x0 <= 72969) or
                 (x0 >= 72971 and x0 <= 73008) or x0 === 73030 or (x0 >= 73056 and x0 <= 73061) or
                 (x0 >= 73063 and x0 <= 73064) or (x0 >= 73066 and x0 <= 73097) or x0 === 73112 or
                 (x0 >= 73440 and x0 <= 73458) or x0 === 73648 or (x0 >= 73728 and x0 <= 74649) or
                 (x0 >= 74752 and x0 <= 74862) or (x0 >= 74880 and x0 <= 75075) or
                 (x0 >= 77824 and x0 <= 78894) or (x0 >= 82944 and x0 <= 83526) or
                 (x0 >= 92160 and x0 <= 92728) or (x0 >= 92736 and x0 <= 92766) or
                 (x0 >= 92880 and x0 <= 92909) or (x0 >= 92928 and x0 <= 92975) or
                 (x0 >= 92992 and x0 <= 92995) or (x0 >= 93027 and x0 <= 93047) or
                 (x0 >= 93053 and x0 <= 93071) or (x0 >= 93792 and x0 <= 93823) or
                 (x0 >= 93952 and x0 <= 94026) or x0 === 94032 or (x0 >= 94099 and x0 <= 94111) or
                 (x0 >= 94176 and x0 <= 94177) or x0 === 94179 or (x0 >= 94208 and x0 <= 100_343) or
                 (x0 >= 100_352 and x0 <= 101_589) or (x0 >= 101_632 and x0 <= 101_640) or
                 (x0 >= 110_592 and x0 <= 110_878) or (x0 >= 110_928 and x0 <= 110_930) or
                 (x0 >= 110_948 and x0 <= 110_951) or (x0 >= 110_960 and x0 <= 111_355) or
                 (x0 >= 113_664 and x0 <= 113_770) or (x0 >= 113_776 and x0 <= 113_788) or
                 (x0 >= 113_792 and x0 <= 113_800) or (x0 >= 113_808 and x0 <= 113_817) or
                 (x0 >= 119_834 and x0 <= 119_892) or (x0 >= 119_894 and x0 <= 119_911) or
                 (x0 >= 119_938 and x0 <= 119_963) or (x0 >= 119_990 and x0 <= 119_993) or
                 x0 === 119_995 or (x0 >= 119_997 and x0 <= 120_003) or
                 (x0 >= 120_005 and x0 <= 120_015) or (x0 >= 120_042 and x0 <= 120_067) or
                 (x0 >= 120_094 and x0 <= 120_119) or (x0 >= 120_146 and x0 <= 120_171) or
                 (x0 >= 120_198 and x0 <= 120_223) or (x0 >= 120_250 and x0 <= 120_275) or
                 (x0 >= 120_302 and x0 <= 120_327) or (x0 >= 120_354 and x0 <= 120_379) or
                 (x0 >= 120_406 and x0 <= 120_431) or (x0 >= 120_458 and x0 <= 120_485) or
                 (x0 >= 120_514 and x0 <= 120_538) or (x0 >= 120_540 and x0 <= 120_545) or
                 (x0 >= 120_572 and x0 <= 120_596) or (x0 >= 120_598 and x0 <= 120_603) or
                 (x0 >= 120_630 and x0 <= 120_654) or (x0 >= 120_656 and x0 <= 120_661) or
                 (x0 >= 120_688 and x0 <= 120_712) or (x0 >= 120_714 and x0 <= 120_719) or
                 (x0 >= 120_746 and x0 <= 120_770) or (x0 >= 120_772 and x0 <= 120_777) or
                 x0 === 120_779 or (x0 >= 123_136 and x0 <= 123_180) or
                 (x0 >= 123_191 and x0 <= 123_197) or x0 === 123_214 or
                 (x0 >= 123_584 and x0 <= 123_627) or (x0 >= 124_928 and x0 <= 125_124) or
                 (x0 >= 125_218 and x0 <= 125_251) or x0 === 125_259 or
                 (x0 >= 126_464 and x0 <= 126_467) or (x0 >= 126_469 and x0 <= 126_495) or
                 (x0 >= 126_497 and x0 <= 126_498) or x0 === 126_500 or x0 === 126_503 or
                 (x0 >= 126_505 and x0 <= 126_514) or (x0 >= 126_516 and x0 <= 126_519) or
                 x0 === 126_521 or x0 === 126_523 or x0 === 126_530 or x0 === 126_535 or
                 x0 === 126_537 or x0 === 126_539 or (x0 >= 126_541 and x0 <= 126_543) or
                 (x0 >= 126_545 and x0 <= 126_546) or x0 === 126_548 or x0 === 126_551 or
                 x0 === 126_553 or x0 === 126_555 or x0 === 126_557 or x0 === 126_559 or
                 (x0 >= 126_561 and x0 <= 126_562) or x0 === 126_564 or
                 (x0 >= 126_567 and x0 <= 126_570) or (x0 >= 126_572 and x0 <= 126_578) or
                 (x0 >= 126_580 and x0 <= 126_583) or (x0 >= 126_585 and x0 <= 126_588) or
                 x0 === 126_590 or (x0 >= 126_592 and x0 <= 126_601) or
                 (x0 >= 126_603 and x0 <= 126_619) or (x0 >= 126_625 and x0 <= 126_627) or
                 (x0 >= 126_629 and x0 <= 126_633) or (x0 >= 126_635 and x0 <= 126_651) or
                 (x0 >= 131_072 and x0 <= 173_789) or (x0 >= 173_824 and x0 <= 177_972) or
                 (x0 >= 177_984 and x0 <= 178_205) or (x0 >= 178_208 and x0 <= 183_969) or
                 (x0 >= 183_984 and x0 <= 191_456) or (x0 >= 194_560 and x0 <= 195_101) or
                 (x0 >= 196_608 and x0 <= 201_546) do
        variable_start_chars__1(
          rest,
          [x0] ++ acc,
          stack,
          context,
          comb__line,
          comb__offset + byte_size(<<x0::utf8>>)
        )
      end

      def variable_start_chars__0(rest, _acc, _stack, context, line, offset) do
        {:error,
         "expected utf8 codepoint equal to '_' or in the range 'a' to 'z' or equal to 'ª' or equal to 'µ' or equal to 'º' or in the range 'ß' to 'ö' or in the range 'ø' to 'ÿ' or equal to 'ā' or equal to 'ă' or equal to 'ą' or equal to 'ć' or equal to 'ĉ' or equal to 'ċ' or equal to 'č' or equal to 'ď' or equal to 'đ' or equal to 'ē' or equal to 'ĕ' or equal to 'ė' or equal to 'ę' or equal to 'ě' or equal to 'ĝ' or equal to 'ğ' or equal to 'ġ' or equal to 'ģ' or equal to 'ĥ' or equal to 'ħ' or equal to 'ĩ' or equal to 'ī' or equal to 'ĭ' or equal to 'į' or equal to 'ı' or equal to 'ĳ' or equal to 'ĵ' or in the range 'ķ' to 'ĸ' or equal to 'ĺ' or equal to 'ļ' or equal to 'ľ' or equal to 'ŀ' or equal to 'ł' or equal to 'ń' or equal to 'ņ' or in the range 'ň' to 'ŉ' or equal to 'ŋ' or equal to 'ō' or equal to 'ŏ' or equal to 'ő' or equal to 'œ' or equal to 'ŕ' or equal to 'ŗ' or equal to 'ř' or equal to 'ś' or equal to 'ŝ' or equal to 'ş' or equal to 'š' or equal to 'ţ' or equal to 'ť' or equal to 'ŧ' or equal to 'ũ' or equal to 'ū' or equal to 'ŭ' or equal to 'ů' or equal to 'ű' or equal to 'ų' or equal to 'ŵ' or equal to 'ŷ' or equal to 'ź' or equal to 'ż' or in the range 'ž' to 'ƀ' or equal to 'ƃ' or equal to 'ƅ' or equal to 'ƈ' or in the range 'ƌ' to 'ƍ' or equal to 'ƒ' or equal to 'ƕ' or in the range 'ƙ' to 'ƛ' or equal to 'ƞ' or equal to 'ơ' or equal to 'ƣ' or equal to 'ƥ' or equal to 'ƨ' or in the range 'ƪ' to 'ƫ' or equal to 'ƭ' or equal to 'ư' or equal to 'ƴ' or equal to 'ƶ' or in the range 'ƹ' to 'ƻ' or in the range 'ƽ' to 'ǃ' or equal to 'ǆ' or equal to 'ǉ' or equal to 'ǌ' or equal to 'ǎ' or equal to 'ǐ' or equal to 'ǒ' or equal to 'ǔ' or equal to 'ǖ' or equal to 'ǘ' or equal to 'ǚ' or in the range 'ǜ' to 'ǝ' or equal to 'ǟ' or equal to 'ǡ' or equal to 'ǣ' or equal to 'ǥ' or equal to 'ǧ' or equal to 'ǩ' or equal to 'ǫ' or equal to 'ǭ' or in the range 'ǯ' to 'ǰ' or equal to 'ǳ' or equal to 'ǵ' or equal to 'ǹ' or equal to 'ǻ' or equal to 'ǽ' or equal to 'ǿ' or equal to 'ȁ' or equal to 'ȃ' or equal to 'ȅ' or equal to 'ȇ' or equal to 'ȉ' or equal to 'ȋ' or equal to 'ȍ' or equal to 'ȏ' or equal to 'ȑ' or equal to 'ȓ' or equal to 'ȕ' or equal to 'ȗ' or equal to 'ș' or equal to 'ț' or equal to 'ȝ' or equal to 'ȟ' or equal to 'ȡ' or equal to 'ȣ' or equal to 'ȥ' or equal to 'ȧ' or equal to 'ȩ' or equal to 'ȫ' or equal to 'ȭ' or equal to 'ȯ' or equal to 'ȱ' or in the range 'ȳ' to 'ȹ' or equal to 'ȼ' or in the range 'ȿ' to 'ɀ' or equal to 'ɂ' or equal to 'ɇ' or equal to 'ɉ' or equal to 'ɋ' or equal to 'ɍ' or in the range 'ɏ' to 'ˁ' or in the range 'ˆ' to 'ˑ' or in the range 'ˠ' to 'ˤ' or equal to 'ˬ' or equal to 'ˮ' or in the range 'ͱ' to 'ʹ' or equal to 'ͷ' or in the range 'ͺ' to 'ͽ' or in the range 'ΐ' to 'Ρ' or in the range 'ά' to 'ϵ' or in the range 'ϸ' to 'ҁ' or in the range 'ҋ' to 'ԯ' or equal to 'ՙ' or in the range 'ՠ' to 'ֈ' or in the range 'א' to 'ת' or in the range 'ׯ' to 'ײ' or in the range 'ؠ' to 'ي' or in the range 'ٮ' to 'ٯ' or in the range 'ٱ' to 'ۓ' or equal to 'ە' or in the range 'ۥ' to 'ۦ' or in the range 'ۮ' to 'ۯ' or in the range 'ۺ' to 'ۼ' or equal to 'ۿ' or equal to 'ܐ' or in the range 'ܒ' to 'ܯ' or in the range 'ݍ' to 'ޥ' or equal to 'ޱ' or in the range 'ߊ' to 'ߪ' or in the range 'ߴ' to 'ߵ' or equal to 'ߺ' or in the range 'ࠀ' to 'ࠕ' or equal to 'ࠚ' or equal to 'ࠤ' or equal to 'ࠨ' or in the range 'ࡀ' to 'ࡘ' or in the range 'ࡠ' to 'ࡪ' or in the range 'ࢠ' to 'ࢴ' or in the range 'ࢶ' to 'ࣇ' or in the range 'ऄ' to 'ह' or equal to 'ऽ' or equal to 'ॐ' or in the range 'क़' to 'ॡ' or in the range 'ॱ' to 'ঀ' or in the range 'অ' to 'ঌ' or in the range 'এ' to 'ঐ' or in the range 'ও' to 'ন' or in the range 'প' to 'র' or equal to 'ল' or in the range 'শ' to 'হ' or equal to 'ঽ' or equal to 'ৎ' or in the range 'ড়' to 'ঢ়' or in the range 'য়' to 'ৡ' or in the range 'ৰ' to 'ৱ' or equal to 'ৼ' or in the range 'ਅ' to 'ਊ' or in the range 'ਏ' to 'ਐ' or in the range 'ਓ' to 'ਨ' or in the range 'ਪ' to 'ਰ' or in the range 'ਲ' to 'ਲ਼' or in the range 'ਵ' to 'ਸ਼' or in the range 'ਸ' to 'ਹ' or in the range 'ਖ਼' to 'ੜ' or equal to 'ਫ਼' or in the range 'ੲ' to 'ੴ' or in the range 'અ' to 'ઍ' or in the range 'એ' to 'ઑ' or in the range 'ઓ' to 'ન' or in the range 'પ' to 'ર' or in the range 'લ' to 'ળ' or in the range 'વ' to 'હ' or equal to 'ઽ' or equal to 'ૐ' or in the range 'ૠ' to 'ૡ' or equal to 'ૹ' or in the range 'ଅ' to 'ଌ' or in the range 'ଏ' to 'ଐ' or in the range 'ଓ' to 'ନ' or in the range 'ପ' to 'ର' or in the range 'ଲ' to 'ଳ' or in the range 'ଵ' to 'ହ' or equal to 'ଽ' or in the range 'ଡ଼' to 'ଢ଼' or in the range 'ୟ' to 'ୡ' or equal to 'ୱ' or equal to 'ஃ' or in the range 'அ' to 'ஊ' or in the range 'எ' to 'ஐ' or in the range 'ஒ' to 'க' or in the range 'ங' to 'ச' or equal to 'ஜ' or in the range 'ஞ' to 'ட' or in the range 'ண' to 'த' or in the range 'ந' to 'ப' or in the range 'ம' to 'ஹ' or equal to 'ௐ' or in the range 'అ' to 'ఌ' or in the range 'ఎ' to 'ఐ' or in the range 'ఒ' to 'న' or in the range 'ప' to 'హ' or equal to 'ఽ' or in the range 'ౘ' to 'ౚ' or in the range 'ౠ' to 'ౡ' or equal to 'ಀ' or in the range 'ಅ' to 'ಌ' or in the range 'ಎ' to 'ಐ' or in the range 'ಒ' to 'ನ' or in the range 'ಪ' to 'ಳ' or in the range 'ವ' to 'ಹ' or equal to 'ಽ' or equal to 'ೞ' or in the range 'ೠ' to 'ೡ' or in the range 'ೱ' to 'ೲ' or in the range 'ഄ' to 'ഌ' or in the range 'എ' to 'ഐ' or in the range 'ഒ' to 'ഺ' or equal to 'ഽ' or equal to 'ൎ' or in the range 'ൔ' to 'ൖ' or in the range 'ൟ' to 'ൡ' or in the range 'ൺ' to 'ൿ' or in the range 'අ' to 'ඖ' or in the range 'ක' to 'න' or in the range 'ඳ' to 'ර' or equal to 'ල' or in the range 'ව' to 'ෆ' or in the range 'ก' to 'ะ' or in the range 'า' to 'ำ' or in the range 'เ' to 'ๆ' or in the range 'ກ' to 'ຂ' or equal to 'ຄ' or in the range 'ຆ' to 'ຊ' or in the range 'ຌ' to 'ຣ' or equal to 'ລ' or in the range 'ວ' to 'ະ' or in the range 'າ' to 'ຳ' or equal to 'ຽ' or in the range 'ເ' to 'ໄ' or equal to 'ໆ' or in the range 'ໜ' to 'ໟ' or equal to 'ༀ' or in the range 'ཀ' to 'ཇ' or in the range 'ཉ' to 'ཬ' or in the range 'ྈ' to 'ྌ' or in the range 'က' to 'ဪ' or equal to 'ဿ' or in the range 'ၐ' to 'ၕ' or in the range 'ၚ' to 'ၝ' or equal to 'ၡ' or in the range 'ၥ' to 'ၦ' or in the range 'ၮ' to 'ၰ' or in the range 'ၵ' to 'ႁ' or equal to 'ႎ' or in the range 'ა' to 'ჺ' or in the range 'ჼ' to 'ቈ' or in the range 'ቊ' to 'ቍ' or in the range 'ቐ' to 'ቖ' or equal to 'ቘ' or in the range 'ቚ' to 'ቝ' or in the range 'በ' to 'ኈ' or in the range 'ኊ' to 'ኍ' or in the range 'ነ' to 'ኰ' or in the range 'ኲ' to 'ኵ' or in the range 'ኸ' to 'ኾ' or equal to 'ዀ' or in the range 'ዂ' to 'ዅ' or in the range 'ወ' to 'ዖ' or in the range 'ዘ' to 'ጐ' or in the range 'ጒ' to 'ጕ' or in the range 'ጘ' to 'ፚ' or in the range 'ᎀ' to 'ᎏ' or in the range 'ᏸ' to 'ᏽ' or in the range 'ᐁ' to 'ᙬ' or in the range 'ᙯ' to 'ᙿ' or in the range 'ᚁ' to 'ᚚ' or in the range 'ᚠ' to 'ᛪ' or in the range 'ᛮ' to 'ᛸ' or in the range 'ᜀ' to 'ᜌ' or in the range 'ᜎ' to 'ᜑ' or in the range 'ᜠ' to 'ᜱ' or in the range 'ᝀ' to 'ᝑ' or in the range 'ᝠ' to 'ᝬ' or in the range 'ᝮ' to 'ᝰ' or in the range 'ក' to 'ឳ' or equal to 'ៗ' or equal to 'ៜ' or in the range 'ᠠ' to 'ᡸ' or in the range 'ᢀ' to 'ᢨ' or equal to 'ᢪ' or in the range 'ᢰ' to 'ᣵ' or in the range 'ᤀ' to 'ᤞ' or in the range 'ᥐ' to 'ᥭ' or in the range 'ᥰ' to 'ᥴ' or in the range 'ᦀ' to 'ᦫ' or in the range 'ᦰ' to 'ᧉ' or in the range 'ᨀ' to 'ᨖ' or in the range 'ᨠ' to 'ᩔ' or equal to 'ᪧ' or in the range 'ᬅ' to 'ᬳ' or in the range 'ᭅ' to 'ᭋ' or in the range 'ᮃ' to 'ᮠ' or in the range 'ᮮ' to 'ᮯ' or in the range 'ᮺ' to 'ᯥ' or in the range 'ᰀ' to 'ᰣ' or in the range 'ᱍ' to 'ᱏ' or in the range 'ᱚ' to 'ᱽ' or in the range 'ᲀ' to 'ᲈ' or in the range 'ᳩ' to 'ᳬ' or in the range 'ᳮ' to 'ᳳ' or in the range 'ᳵ' to 'ᳶ' or equal to 'ᳺ' or in the range 'ᴀ' to 'ᶿ' or in the range 'ḁ' to 'ἕ' or in the range 'ἠ' to 'ἧ' or in the range 'ἰ' to 'ἷ' or in the range 'ὀ' to 'ὅ' or in the range 'ὐ' to 'ὗ' or in the range 'ὠ' to 'ώ' or in the range 'ᾀ' to 'ᾇ' or in the range 'ᾐ' to 'ᾗ' or in the range 'ᾠ' to 'ᾧ' or in the range 'ᾰ' to 'ᾴ' or in the range 'ᾶ' to 'ᾷ' or equal to 'ι' or in the range 'ῂ' to 'ῄ' or in the range 'ῆ' to 'ῇ' or in the range 'ῐ' to 'ΐ' or in the range 'ῖ' to 'ῗ' or in the range 'ῠ' to 'ῧ' or in the range 'ῲ' to 'ῴ' or in the range 'ῶ' to 'ῷ' or equal to 'ⁱ' or equal to 'ⁿ' or in the range 'ₐ' to 'ₜ' or equal to 'ℊ' or in the range 'ℎ' to 'ℏ' or equal to 'ℓ' or equal to '℘' or in the range '℮' to 'ℹ' or in the range 'ℼ' to 'ℽ' or in the range 'ⅆ' to 'ⅉ' or equal to 'ⅎ' or in the range 'Ⅰ' to 'ↂ' or in the range 'ↄ' to 'ↈ' or in the range 'ⰰ' to 'ⱞ' or in the range 'ⱡ' to 'ⳤ' or in the range 'ⳬ' to 'ⳮ' or equal to 'ⳳ' or in the range 'ⴀ' to 'ⴥ' or equal to 'ⴧ' or equal to 'ⴭ' or in the range 'ⴰ' to 'ⵧ' or equal to 'ⵯ' or in the range 'ⶀ' to 'ⶖ' or in the range 'ⶠ' to 'ⶦ' or in the range 'ⶨ' to 'ⶮ' or in the range 'ⶰ' to 'ⶶ' or in the range 'ⶸ' to 'ⶾ' or in the range 'ⷀ' to 'ⷆ' or in the range 'ⷈ' to 'ⷎ' or in the range 'ⷐ' to 'ⷖ' or in the range 'ⷘ' to 'ⷞ' or in the range '々' to '〇' or in the range '〡' to '〩' or in the range '〱' to '〵' or in the range '〸' to '〼' or in the range 'ぁ' to 'ゖ' or in the range '゛' to 'ゟ' or in the range 'ァ' to 'ヺ' or in the range 'ー' to 'ヿ' or in the range 'ㄅ' to 'ㄯ' or in the range 'ㄱ' to 'ㆎ' or in the range 'ㆠ' to 'ㆿ' or in the range 'ㇰ' to 'ㇿ' or in the range '㐀' to '䶿' or in the range '一' to '鿼' or in the range 'ꀀ' to 'ꒌ' or in the range 'ꓐ' to 'ꓽ' or in the range 'ꔀ' to 'ꘌ' or in the range 'ꘐ' to 'ꘟ' or in the range 'ꘪ' to 'ꘫ' or in the range 'ꙁ' to 'ꙮ' or equal to 'ꙿ' or equal to 'ꚁ' or equal to 'ꚃ' or equal to 'ꚅ' or equal to 'ꚇ' or equal to 'ꚉ' or equal to 'ꚋ' or equal to 'ꚍ' or equal to 'ꚏ' or equal to 'ꚑ' or equal to 'ꚓ' or equal to 'ꚕ' or equal to 'ꚗ' or equal to 'ꚙ' or in the range 'ꚛ' to 'ꚝ' or in the range 'ꚠ' to 'ꛯ' or in the range 'ꜗ' to 'ꜟ' or in the range 'ꜣ' to 'ꞈ' or in the range 'ꞌ' to 'ꞿ' or in the range 'ꟃ' to 'ꟊ' or in the range 'ꟶ' to 'ꠁ' or in the range 'ꠃ' to 'ꠅ' or in the range 'ꠇ' to 'ꠊ' or in the range 'ꠌ' to 'ꠢ' or in the range 'ꡀ' to 'ꡳ' or in the range 'ꢂ' to 'ꢳ' or in the range 'ꣲ' to 'ꣷ' or equal to 'ꣻ' or in the range 'ꣽ' to 'ꣾ' or in the range 'ꤊ' to 'ꤥ' or in the range 'ꤰ' to 'ꥆ' or in the range 'ꥠ' to 'ꥼ' or in the range 'ꦄ' to 'ꦲ' or equal to 'ꧏ' or in the range 'ꧠ' to 'ꧤ' or in the range 'ꧦ' to 'ꧯ' or in the range 'ꧺ' to 'ꧾ' or in the range 'ꨀ' to 'ꨨ' or in the range 'ꩀ' to 'ꩂ' or in the range 'ꩄ' to 'ꩋ' or in the range 'ꩠ' to 'ꩶ' or equal to 'ꩺ' or in the range 'ꩾ' to 'ꪯ' or equal to 'ꪱ' or in the range 'ꪵ' to 'ꪶ' or in the range 'ꪹ' to 'ꪽ' or equal to 'ꫀ' or equal to 'ꫂ' or in the range 'ꫛ' to 'ꫝ' or in the range 'ꫠ' to 'ꫪ' or in the range 'ꫲ' to 'ꫴ' or in the range 'ꬁ' to 'ꬆ' or in the range 'ꬉ' to 'ꬎ' or in the range 'ꬑ' to 'ꬖ' or in the range 'ꬠ' to 'ꬦ' or in the range 'ꬨ' to 'ꬮ' or in the range 'ꬰ' to 'ꭚ' or in the range 'ꭜ' to 'ꭩ' or in the range 'ꭰ' to 'ꯢ' or in the range '가' to '힣' or in the range 'ힰ' to 'ퟆ' or in the range 'ퟋ' to 'ퟻ' or in the range '豈' to '舘' or in the range '並' to '龎' or in the range 'ﬀ' to 'ﬆ' or in the range 'ﬓ' to 'ﬗ' or equal to 'יִ' or in the range 'ײַ' to 'ﬨ' or in the range 'שׁ' to 'זּ' or in the range 'טּ' to 'לּ' or equal to 'מּ' or in the range 'נּ' to 'סּ' or in the range 'ףּ' to 'פּ' or in the range 'צּ' to 'ﮱ' or in the range 'ﯓ' to 'ﴽ' or in the range 'ﵐ' to 'ﶏ' or in the range 'ﶒ' to 'ﷇ' or in the range 'ﷰ' to 'ﷻ' or in the range 'ﹰ' to 'ﹴ' or in the range 'ﹶ' to 'ﻼ' or in the range 'ａ' to 'ｚ' or in the range 'ｦ' to 'ﾾ' or in the range 'ￂ' to 'ￇ' or in the range 'ￊ' to 'ￏ' or in the range 'ￒ' to 'ￗ' or in the range 'ￚ' to 'ￜ' or in the range '𐀀' to '𐀋' or in the range '𐀍' to '𐀦' or in the range '𐀨' to '𐀺' or in the range '𐀼' to '𐀽' or in the range '𐀿' to '𐁍' or in the range '𐁐' to '𐁝' or in the range '𐂀' to '𐃺' or in the range '𐅀' to '𐅴' or in the range '𐊀' to '𐊜' or in the range '𐊠' to '𐋐' or in the range '𐌀' to '𐌟' or in the range '𐌭' to '𐍊' or in the range '𐍐' to '𐍵' or in the range '𐎀' to '𐎝' or in the range '𐎠' to '𐏃' or in the range '𐏈' to '𐏏' or in the range '𐏑' to '𐏕' or in the range '𐐨' to '𐒝' or in the range '𐓘' to '𐓻' or in the range '𐔀' to '𐔧' or in the range '𐔰' to '𐕣' or in the range '𐘀' to '𐜶' or in the range '𐝀' to '𐝕' or in the range '𐝠' to '𐝧' or in the range '𐠀' to '𐠅' or equal to '𐠈' or in the range '𐠊' to '𐠵' or in the range '𐠷' to '𐠸' or equal to '𐠼' or in the range '𐠿' to '𐡕' or in the range '𐡠' to '𐡶' or in the range '𐢀' to '𐢞' or in the range '𐣠' to '𐣲' or in the range '𐣴' to '𐣵' or in the range '𐤀' to '𐤕' or in the range '𐤠' to '𐤹' or in the range '𐦀' to '𐦷' or in the range '𐦾' to '𐦿' or equal to '𐨀' or in the range '𐨐' to '𐨓' or in the range '𐨕' to '𐨗' or in the range '𐨙' to '𐨵' or in the range '𐩠' to '𐩼' or in the range '𐪀' to '𐪜' or in the range '𐫀' to '𐫇' or in the range '𐫉' to '𐫤' or in the range '𐬀' to '𐬵' or in the range '𐭀' to '𐭕' or in the range '𐭠' to '𐭲' or in the range '𐮀' to '𐮑' or in the range '𐰀' to '𐱈' or in the range '𐳀' to '𐳲' or in the range '𐴀' to '𐴣' or in the range '𐺀' to '𐺩' or in the range '𐺰' to '𐺱' or in the range '𐼀' to '𐼜' or equal to '𐼧' or in the range '𐼰' to '𐽅' or in the range '𐾰' to '𐿄' or in the range '𐿠' to '𐿶' or in the range '𑀃' to '𑀷' or in the range '𑂃' to '𑂯' or in the range '𑃐' to '𑃨' or in the range '𑄃' to '𑄦' or equal to '𑅄' or equal to '𑅇' or in the range '𑅐' to '𑅲' or equal to '𑅶' or in the range '𑆃' to '𑆲' or in the range '𑇁' to '𑇄' or equal to '𑇚' or equal to '𑇜' or in the range '𑈀' to '𑈑' or in the range '𑈓' to '𑈫' or in the range '𑊀' to '𑊆' or equal to '𑊈' or in the range '𑊊' to '𑊍' or in the range '𑊏' to '𑊝' or in the range '𑊟' to '𑊨' or in the range '𑊰' to '𑋞' or in the range '𑌅' to '𑌌' or in the range '𑌏' to '𑌐' or in the range '𑌓' to '𑌨' or in the range '𑌪' to '𑌰' or in the range '𑌲' to '𑌳' or in the range '𑌵' to '𑌹' or equal to '𑌽' or equal to '𑍐' or in the range '𑍝' to '𑍡' or in the range '𑐀' to '𑐴' or in the range '𑑇' to '𑑊' or in the range '𑑟' to '𑑡' or in the range '𑒀' to '𑒯' or in the range '𑓄' to '𑓅' or equal to '𑓇' or in the range '𑖀' to '𑖮' or in the range '𑗘' to '𑗛' or in the range '𑘀' to '𑘯' or equal to '𑙄' or in the range '𑚀' to '𑚪' or equal to '𑚸' or in the range '𑜀' to '𑜚' or in the range '𑠀' to '𑠫' or in the range '𑣀' to '𑣟' or in the range '𑣿' to '𑤆' or equal to '𑤉' or in the range '𑤌' to '𑤓' or in the range '𑤕' to '𑤖' or in the range '𑤘' to '𑤯' or equal to '𑤿' or equal to '𑥁' or in the range '𑦠' to '𑦧' or in the range '𑦪' to '𑧐' or equal to '𑧡' or equal to '𑧣' or equal to '𑨀' or in the range '𑨋' to '𑨲' or equal to '𑨺' or equal to '𑩐' or in the range '𑩜' to '𑪉' or equal to '𑪝' or in the range '𑫀' to '𑫸' or in the range '𑰀' to '𑰈' or in the range '𑰊' to '𑰮' or equal to '𑱀' or in the range '𑱲' to '𑲏' or in the range '𑴀' to '𑴆' or in the range '𑴈' to '𑴉' or in the range '𑴋' to '𑴰' or equal to '𑵆' or in the range '𑵠' to '𑵥' or in the range '𑵧' to '𑵨' or in the range '𑵪' to '𑶉' or equal to '𑶘' or in the range '𑻠' to '𑻲' or equal to '𑾰' or in the range '𒀀' to '𒎙' or in the range '𒐀' to '𒑮' or in the range '𒒀' to '𒕃' or in the range '𓀀' to '𓐮' or in the range '𔐀' to '𔙆' or in the range '𖠀' to '𖨸' or in the range '𖩀' to '𖩞' or in the range '𖫐' to '𖫭' or in the range '𖬀' to '𖬯' or in the range '𖭀' to '𖭃' or in the range '𖭣' to '𖭷' or in the range '𖭽' to '𖮏' or in the range '𖹠' to '𖹿' or in the range '𖼀' to '𖽊' or equal to '𖽐' or in the range '𖾓' to '𖾟' or in the range '𖿠' to '𖿡' or equal to '𖿣' or in the range '𗀀' to '𘟷' or in the range '𘠀' to '𘳕' or in the range '𘴀' to '𘴈' or in the range '𛀀' to '𛄞' or in the range '𛅐' to '𛅒' or in the range '𛅤' to '𛅧' or in the range '𛅰' to '𛋻' or in the range '𛰀' to '𛱪' or in the range '𛱰' to '𛱼' or in the range '𛲀' to '𛲈' or in the range '𛲐' to '𛲙' or in the range '𝐚' to '𝑔' or in the range '𝑖' to '𝑧' or in the range '𝒂' to '𝒛' or in the range '𝒶' to '𝒹' or equal to '𝒻' or in the range '𝒽' to '𝓃' or in the range '𝓅' to '𝓏' or in the range '𝓪' to '𝔃' or in the range '𝔞' to '𝔷' or in the range '𝕒' to '𝕫' or in the range '𝖆' to '𝖟' or in the range '𝖺' to '𝗓' or in the range '𝗮' to '𝘇' or in the range '𝘢' to '𝘻' or in the range '𝙖' to '𝙯' or in the range '𝚊' to '𝚥' or in the range '𝛂' to '𝛚' or in the range '𝛜' to '𝛡' or in the range '𝛼' to '𝜔' or in the range '𝜖' to '𝜛' or in the range '𝜶' to '𝝎' or in the range '𝝐' to '𝝕' or in the range '𝝰' to '𝞈' or in the range '𝞊' to '𝞏' or in the range '𝞪' to '𝟂' or in the range '𝟄' to '𝟉' or equal to '𝟋' or in the range '𞄀' to '𞄬' or in the range '𞄷' to '𞄽' or equal to '𞅎' or in the range '𞋀' to '𞋫' or in the range '𞠀' to '𞣄' or in the range '𞤢' to '𞥃' or equal to '𞥋' or in the range '𞸀' to '𞸃' or in the range '𞸅' to '𞸟' or in the range '𞸡' to '𞸢' or equal to '𞸤' or equal to '𞸧' or in the range '𞸩' to '𞸲' or in the range '𞸴' to '𞸷' or equal to '𞸹' or equal to '𞸻' or equal to '𞹂' or equal to '𞹇' or equal to '𞹉' or equal to '𞹋' or in the range '𞹍' to '𞹏' or in the range '𞹑' to '𞹒' or equal to '𞹔' or equal to '𞹗' or equal to '𞹙' or equal to '𞹛' or equal to '𞹝' or equal to '𞹟' or in the range '𞹡' to '𞹢' or equal to '𞹤' or in the range '𞹧' to '𞹪' or in the range '𞹬' to '𞹲' or in the range '𞹴' to '𞹷' or in the range '𞹹' to '𞹼' or equal to '𞹾' or in the range '𞺀' to '𞺉' or in the range '𞺋' to '𞺛' or in the range '𞺡' to '𞺣' or in the range '𞺥' to '𞺩' or in the range '𞺫' to '𞺻' or in the range '𠀀' to '𪛝' or in the range '𪜀' to '𫜴' or in the range '𫝀' to '𫠝' or in the range '𫠠' to '𬺡' or in the range '𬺰' to '𮯠' or in the range '丽' to '𪘀' or in the range '𰀀' to '𱍊'",
         rest, context, line, offset}
      end

      def variable_start_chars__1(rest, acc, _stack, context, line, offset) do
        {:ok, acc, rest, context, line, offset}
      end
    end
  end

  heresy "together" do
    # Nothing
  end
end