glabel func_808D2748
/* 000D8 808D2748 27BDFFE8 */  addiu   $sp, $sp, 0xFFE8           ## $sp = FFFFFFE8
/* 000DC 808D274C AFBF0014 */  sw      $ra, 0x0014($sp)           
/* 000E0 808D2750 AFA40018 */  sw      $a0, 0x0018($sp)           
/* 000E4 808D2754 00001025 */  or      $v0, $zero, $zero          ## $v0 = 00000000
.L808D2758:
/* 000E8 808D2758 90AE0024 */  lbu     $t6, 0x0024($a1)           ## 00000024
/* 000EC 808D275C 24420001 */  addiu   $v0, $v0, 0x0001           ## $v0 = 00000001
/* 000F0 808D2760 00021400 */  sll     $v0, $v0, 16               
/* 000F4 808D2764 15C00036 */  bne     $t6, $zero, .L808D2840     
/* 000F8 808D2768 00021403 */  sra     $v0, $v0, 16               
/* 000FC 808D276C 240F0004 */  addiu   $t7, $zero, 0x0004         ## $t7 = 00000004
/* 00100 808D2770 A0AF0024 */  sb      $t7, 0x0024($a1)           ## 00000024
/* 00104 808D2774 A0A00025 */  sb      $zero, 0x0025($a1)         ## 00000025
/* 00108 808D2778 8CD90000 */  lw      $t9, 0x0000($a2)           ## 00000000
/* 0010C 808D277C 3C014120 */  lui     $at, 0x4120                ## $at = 41200000
/* 00110 808D2780 44816000 */  mtc1    $at, $f12                  ## $f12 = 10.00
/* 00114 808D2784 ACB90000 */  sw      $t9, 0x0000($a1)           ## 00000000
/* 00118 808D2788 8CD80004 */  lw      $t8, 0x0004($a2)           ## 00000004
/* 0011C 808D278C C4A40000 */  lwc1    $f4, 0x0000($a1)           ## 00000000
/* 00120 808D2790 ACB80004 */  sw      $t8, 0x0004($a1)           ## 00000004
/* 00124 808D2794 8CD90008 */  lw      $t9, 0x0008($a2)           ## 00000008
/* 00128 808D2798 C4AA0004 */  lwc1    $f10, 0x0004($a1)          ## 00000004
/* 0012C 808D279C ACB90008 */  sw      $t9, 0x0008($a1)           ## 00000008
/* 00130 808D27A0 8CE90000 */  lw      $t1, 0x0000($a3)           ## 00000000
/* 00134 808D27A4 ACA9000C */  sw      $t1, 0x000C($a1)           ## 0000000C
/* 00138 808D27A8 8CE80004 */  lw      $t0, 0x0004($a3)           ## 00000004
/* 0013C 808D27AC C4A6000C */  lwc1    $f6, 0x000C($a1)           ## 0000000C
/* 00140 808D27B0 ACA80010 */  sw      $t0, 0x0010($a1)           ## 00000010
/* 00144 808D27B4 8CE90008 */  lw      $t1, 0x0008($a3)           ## 00000008
/* 00148 808D27B8 46062201 */  sub.s   $f8, $f4, $f6              
/* 0014C 808D27BC C4B00010 */  lwc1    $f16, 0x0010($a1)          ## 00000010
/* 00150 808D27C0 ACA90014 */  sw      $t1, 0x0014($a1)           ## 00000014
/* 00154 808D27C4 8FAA0028 */  lw      $t2, 0x0028($sp)           
/* 00158 808D27C8 C4A60014 */  lwc1    $f6, 0x0014($a1)           ## 00000014
/* 0015C 808D27CC C4A40008 */  lwc1    $f4, 0x0008($a1)           ## 00000008
/* 00160 808D27D0 8D4C0000 */  lw      $t4, 0x0000($t2)           ## 00000000
/* 00164 808D27D4 46105481 */  sub.s   $f18, $f10, $f16           
/* 00168 808D27D8 44805000 */  mtc1    $zero, $f10                ## $f10 = 0.00
/* 0016C 808D27DC ACAC0018 */  sw      $t4, 0x0018($a1)           ## 00000018
/* 00170 808D27E0 8D4B0004 */  lw      $t3, 0x0004($t2)           ## 00000004
/* 00174 808D27E4 ACAB001C */  sw      $t3, 0x001C($a1)           ## 0000001C
/* 00178 808D27E8 8D4C0008 */  lw      $t4, 0x0008($t2)           ## 00000008
/* 0017C 808D27EC E4A80000 */  swc1    $f8, 0x0000($a1)           ## 00000000
/* 00180 808D27F0 46062201 */  sub.s   $f8, $f4, $f6              
/* 00184 808D27F4 E4B20004 */  swc1    $f18, 0x0004($a1)          ## 00000004
/* 00188 808D27F8 E4AA0034 */  swc1    $f10, 0x0034($a1)          ## 00000034
/* 0018C 808D27FC ACAC0020 */  sw      $t4, 0x0020($a1)           ## 00000020
/* 00190 808D2800 E4A80008 */  swc1    $f8, 0x0008($a1)           ## 00000008
/* 00194 808D2804 87AD0032 */  lh      $t5, 0x0032($sp)           
/* 00198 808D2808 A4AD002A */  sh      $t5, 0x002A($a1)           ## 0000002A
/* 0019C 808D280C 0C00CFBE */  jal     Math_Rand_ZeroFloat
              
/* 001A0 808D2810 AFA5001C */  sw      $a1, 0x001C($sp)           
/* 001A4 808D2814 8FA5001C */  lw      $a1, 0x001C($sp)           
/* 001A8 808D2818 3C0143C8 */  lui     $at, 0x43C8                ## $at = 43C80000
/* 001AC 808D281C 44819000 */  mtc1    $at, $f18                  ## $f18 = 400.00
/* 001B0 808D2820 E4A00038 */  swc1    $f0, 0x0038($a1)           ## 00000038
/* 001B4 808D2824 A4A0002C */  sh      $zero, 0x002C($a1)         ## 0000002C
/* 001B8 808D2828 C7B0002C */  lwc1    $f16, 0x002C($sp)          
/* 001BC 808D282C 46128103 */  div.s   $f4, $f16, $f18            
/* 001C0 808D2830 E4A40030 */  swc1    $f4, 0x0030($a1)           ## 00000030
/* 001C4 808D2834 87AE0036 */  lh      $t6, 0x0036($sp)           
/* 001C8 808D2838 10000004 */  beq     $zero, $zero, .L808D284C   
/* 001CC 808D283C A4AE002E */  sh      $t6, 0x002E($a1)           ## 0000002E
.L808D2840:
/* 001D0 808D2840 284100B4 */  slti    $at, $v0, 0x00B4           
/* 001D4 808D2844 1420FFC4 */  bne     $at, $zero, .L808D2758     
/* 001D8 808D2848 24A5003C */  addiu   $a1, $a1, 0x003C           ## $a1 = 0000003C
.L808D284C:
/* 001DC 808D284C 8FBF0014 */  lw      $ra, 0x0014($sp)           
/* 001E0 808D2850 27BD0018 */  addiu   $sp, $sp, 0x0018           ## $sp = 00000000
/* 001E4 808D2854 03E00008 */  jr      $ra                        
/* 001E8 808D2858 00000000 */  nop

