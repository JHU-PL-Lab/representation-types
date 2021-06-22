
tests/trees-clang.exe:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	f3 0f 1e fa          	endbr64 
    1004:	48 83 ec 08          	sub    rsp,0x8
    1008:	48 8b 05 d9 6f 00 00 	mov    rax,QWORD PTR [rip+0x6fd9]        # 7fe8 <__gmon_start__>
    100f:	48 85 c0             	test   rax,rax
    1012:	74 02                	je     1016 <_init+0x16>
    1014:	ff d0                	call   rax
    1016:	48 83 c4 08          	add    rsp,0x8
    101a:	c3                   	ret    

Disassembly of section .plt:

0000000000001020 <__stack_chk_fail@plt-0x10>:
    1020:	ff 35 e2 6f 00 00    	push   QWORD PTR [rip+0x6fe2]        # 8008 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	ff 25 e4 6f 00 00    	jmp    QWORD PTR [rip+0x6fe4]        # 8010 <_GLOBAL_OFFSET_TABLE_+0x10>
    102c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

0000000000001030 <__stack_chk_fail@plt>:
    1030:	ff 25 e2 6f 00 00    	jmp    QWORD PTR [rip+0x6fe2]        # 8018 <__stack_chk_fail@GLIBC_2.4>
    1036:	68 00 00 00 00       	push   0x0
    103b:	e9 e0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001040 <srand@plt>:
    1040:	ff 25 da 6f 00 00    	jmp    QWORD PTR [rip+0x6fda]        # 8020 <srand@GLIBC_2.2.5>
    1046:	68 01 00 00 00       	push   0x1
    104b:	e9 d0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001050 <fprintf@plt>:
    1050:	ff 25 d2 6f 00 00    	jmp    QWORD PTR [rip+0x6fd2]        # 8028 <fprintf@GLIBC_2.2.5>
    1056:	68 02 00 00 00       	push   0x2
    105b:	e9 c0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001060 <time@plt>:
    1060:	ff 25 ca 6f 00 00    	jmp    QWORD PTR [rip+0x6fca]        # 8030 <time@GLIBC_2.2.5>
    1066:	68 03 00 00 00       	push   0x3
    106b:	e9 b0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001070 <malloc@plt>:
    1070:	ff 25 c2 6f 00 00    	jmp    QWORD PTR [rip+0x6fc2]        # 8038 <malloc@GLIBC_2.2.5>
    1076:	68 04 00 00 00       	push   0x4
    107b:	e9 a0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001080 <__isoc99_scanf@plt>:
    1080:	ff 25 ba 6f 00 00    	jmp    QWORD PTR [rip+0x6fba]        # 8040 <__isoc99_scanf@GLIBC_2.7>
    1086:	68 05 00 00 00       	push   0x5
    108b:	e9 90 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001090 <exit@plt>:
    1090:	ff 25 b2 6f 00 00    	jmp    QWORD PTR [rip+0x6fb2]        # 8048 <exit@GLIBC_2.2.5>
    1096:	68 06 00 00 00       	push   0x6
    109b:	e9 80 ff ff ff       	jmp    1020 <_init+0x20>

Disassembly of section .text:

00000000000010a0 <set_fast_math>:
    10a0:	f3 0f 1e fa          	endbr64 
    10a4:	0f ae 5c 24 fc       	stmxcsr DWORD PTR [rsp-0x4]
    10a9:	81 4c 24 fc 40 80 00 	or     DWORD PTR [rsp-0x4],0x8040
    10b0:	00 
    10b1:	0f ae 54 24 fc       	ldmxcsr DWORD PTR [rsp-0x4]
    10b6:	c3                   	ret    
    10b7:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
    10be:	00 00 

00000000000010c0 <_start>:
    10c0:	f3 0f 1e fa          	endbr64 
    10c4:	31 ed                	xor    ebp,ebp
    10c6:	49 89 d1             	mov    r9,rdx
    10c9:	5e                   	pop    rsi
    10ca:	48 89 e2             	mov    rdx,rsp
    10cd:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
    10d1:	50                   	push   rax
    10d2:	54                   	push   rsp
    10d3:	4c 8d 05 46 1f 00 00 	lea    r8,[rip+0x1f46]        # 3020 <__libc_csu_fini>
    10da:	48 8d 0d cf 1e 00 00 	lea    rcx,[rip+0x1ecf]        # 2fb0 <__libc_csu_init>
    10e1:	48 8d 3d 58 1e 00 00 	lea    rdi,[rip+0x1e58]        # 2f40 <main>
    10e8:	ff 15 f2 6e 00 00    	call   QWORD PTR [rip+0x6ef2]        # 7fe0 <__libc_start_main@GLIBC_2.2.5>
    10ee:	f4                   	hlt    
    10ef:	90                   	nop

00000000000010f0 <deregister_tm_clones>:
    10f0:	48 8d 3d 69 6f 00 00 	lea    rdi,[rip+0x6f69]        # 8060 <__TMC_END__>
    10f7:	48 8d 05 62 6f 00 00 	lea    rax,[rip+0x6f62]        # 8060 <__TMC_END__>
    10fe:	48 39 f8             	cmp    rax,rdi
    1101:	74 15                	je     1118 <deregister_tm_clones+0x28>
    1103:	48 8b 05 c6 6e 00 00 	mov    rax,QWORD PTR [rip+0x6ec6]        # 7fd0 <_ITM_deregisterTMCloneTable>
    110a:	48 85 c0             	test   rax,rax
    110d:	74 09                	je     1118 <deregister_tm_clones+0x28>
    110f:	ff e0                	jmp    rax
    1111:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    1118:	c3                   	ret    
    1119:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001120 <register_tm_clones>:
    1120:	48 8d 3d 39 6f 00 00 	lea    rdi,[rip+0x6f39]        # 8060 <__TMC_END__>
    1127:	48 8d 35 32 6f 00 00 	lea    rsi,[rip+0x6f32]        # 8060 <__TMC_END__>
    112e:	48 29 fe             	sub    rsi,rdi
    1131:	48 89 f0             	mov    rax,rsi
    1134:	48 c1 ee 3f          	shr    rsi,0x3f
    1138:	48 c1 f8 03          	sar    rax,0x3
    113c:	48 01 c6             	add    rsi,rax
    113f:	48 d1 fe             	sar    rsi,1
    1142:	74 14                	je     1158 <register_tm_clones+0x38>
    1144:	48 8b 05 a5 6e 00 00 	mov    rax,QWORD PTR [rip+0x6ea5]        # 7ff0 <_ITM_registerTMCloneTable>
    114b:	48 85 c0             	test   rax,rax
    114e:	74 08                	je     1158 <register_tm_clones+0x38>
    1150:	ff e0                	jmp    rax
    1152:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    1158:	c3                   	ret    
    1159:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001160 <__do_global_dtors_aux>:
    1160:	f3 0f 1e fa          	endbr64 
    1164:	80 3d f5 6e 00 00 00 	cmp    BYTE PTR [rip+0x6ef5],0x0        # 8060 <__TMC_END__>
    116b:	75 33                	jne    11a0 <__do_global_dtors_aux+0x40>
    116d:	55                   	push   rbp
    116e:	48 83 3d 82 6e 00 00 	cmp    QWORD PTR [rip+0x6e82],0x0        # 7ff8 <__cxa_finalize@GLIBC_2.2.5>
    1175:	00 
    1176:	48 89 e5             	mov    rbp,rsp
    1179:	74 0d                	je     1188 <__do_global_dtors_aux+0x28>
    117b:	48 8b 3d d6 6e 00 00 	mov    rdi,QWORD PTR [rip+0x6ed6]        # 8058 <__dso_handle>
    1182:	ff 15 70 6e 00 00    	call   QWORD PTR [rip+0x6e70]        # 7ff8 <__cxa_finalize@GLIBC_2.2.5>
    1188:	e8 63 ff ff ff       	call   10f0 <deregister_tm_clones>
    118d:	c6 05 cc 6e 00 00 01 	mov    BYTE PTR [rip+0x6ecc],0x1        # 8060 <__TMC_END__>
    1194:	5d                   	pop    rbp
    1195:	c3                   	ret    
    1196:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    119d:	00 00 00 
    11a0:	c3                   	ret    
    11a1:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    11a8:	00 00 00 00 
    11ac:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

00000000000011b0 <frame_dummy>:
    11b0:	f3 0f 1e fa          	endbr64 
    11b4:	e9 67 ff ff ff       	jmp    1120 <register_tm_clones>
    11b9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

00000000000011c0 <__input>:
    11c0:	50                   	push   rax
    11c1:	48 89 fe             	mov    rsi,rdi
    11c4:	48 8d 3d 05 50 00 00 	lea    rdi,[rip+0x5005]        # 61d0 <_IO_stdin_used+0x21d0>
    11cb:	31 c0                	xor    eax,eax
    11cd:	e8 ae fe ff ff       	call   1080 <__isoc99_scanf@plt>
    11d2:	83 f8 01             	cmp    eax,0x1
    11d5:	75 02                	jne    11d9 <__input+0x19>
    11d7:	58                   	pop    rax
    11d8:	c3                   	ret    
    11d9:	bf 01 00 00 00       	mov    edi,0x1
    11de:	e8 ad fe ff ff       	call   1090 <exit@plt>
    11e3:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    11ea:	00 00 00 
    11ed:	0f 1f 00             	nop    DWORD PTR [rax]

00000000000011f0 <___main>:
    11f0:	55                   	push   rbp
    11f1:	41 57                	push   r15
    11f3:	41 56                	push   r14
    11f5:	41 55                	push   r13
    11f7:	41 54                	push   r12
    11f9:	53                   	push   rbx
    11fa:	48 83 ec 48          	sub    rsp,0x48
    11fe:	48 89 74 24 08       	mov    QWORD PTR [rsp+0x8],rsi
    1203:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    120a:	00 00 
    120c:	48 89 44 24 40       	mov    QWORD PTR [rsp+0x40],rax
    1211:	bf 18 00 00 00       	mov    edi,0x18
    1216:	e8 55 fe ff ff       	call   1070 <malloc@plt>
    121b:	49 89 c6             	mov    r14,rax
    121e:	48 8d 05 cb 07 00 00 	lea    rax,[rip+0x7cb]        # 19f0 <_map_data$0>
    1225:	49 89 06             	mov    QWORD PTR [r14],rax
    1228:	48 8d 1d 91 6b 00 00 	lea    rbx,[rip+0x6b91]        # 7dc0 <___main._Blk$0$>
    122f:	49 89 5e 08          	mov    QWORD PTR [r14+0x8],rbx
    1233:	4c 8d 3d 7e 6b 00 00 	lea    r15,[rip+0x6b7e]        # 7db8 <___main._Red$0$>
    123a:	4d 89 7e 10          	mov    QWORD PTR [r14+0x10],r15
    123e:	bf 20 00 00 00       	mov    edi,0x20
    1243:	e8 28 fe ff ff       	call   1070 <malloc@plt>
    1248:	48 89 c5             	mov    rbp,rax
    124b:	48 8d 05 ee 07 00 00 	lea    rax,[rip+0x7ee]        # 1a40 <_balance$0>
    1252:	48 89 45 00          	mov    QWORD PTR [rbp+0x0],rax
    1256:	48 89 5d 08          	mov    QWORD PTR [rbp+0x8],rbx
    125a:	4c 89 7d 10          	mov    QWORD PTR [rbp+0x10],r15
    125e:	48 8d 05 63 6b 00 00 	lea    rax,[rip+0x6b63]        # 7dc8 <___main._blacken$0$>
    1265:	48 89 45 18          	mov    QWORD PTR [rbp+0x18],rax
    1269:	bf 38 00 00 00       	mov    edi,0x38
    126e:	e8 fd fd ff ff       	call   1070 <malloc@plt>
    1273:	48 89 c3             	mov    rbx,rax
    1276:	48 8d 05 63 1a 00 00 	lea    rax,[rip+0x1a63]        # 2ce0 <_insert$0>
    127d:	48 89 03             	mov    QWORD PTR [rbx],rax
    1280:	4c 89 7b 08          	mov    QWORD PTR [rbx+0x8],r15
    1284:	48 89 6b 10          	mov    QWORD PTR [rbx+0x10],rbp
    1288:	c7 43 18 0a 00 00 00 	mov    DWORD PTR [rbx+0x18],0xa
    128f:	48 8d 05 3a 6b 00 00 	lea    rax,[rip+0x6b3a]        # 7dd0 <___main._get_value$0$>
    1296:	48 89 43 28          	mov    QWORD PTR [rbx+0x28],rax
    129a:	4c 89 73 30          	mov    QWORD PTR [rbx+0x30],r14
    129e:	48 8d 3d 2b 4f 00 00 	lea    rdi,[rip+0x4f2b]        # 61d0 <_IO_stdin_used+0x21d0>
    12a5:	48 8d 74 24 38       	lea    rsi,[rsp+0x38]
    12aa:	31 c0                	xor    eax,eax
    12ac:	e8 cf fd ff ff       	call   1080 <__isoc99_scanf@plt>
    12b1:	83 f8 01             	cmp    eax,0x1
    12b4:	75 78                	jne    132e <___main+0x13e>
    12b6:	41 bc 0a 00 00 00    	mov    r12d,0xa
    12bc:	48 8d 6c 24 10       	lea    rbp,[rsp+0x10]
    12c1:	4c 8d 35 08 4f 00 00 	lea    r14,[rip+0x4f08]        # 61d0 <_IO_stdin_used+0x21d0>
    12c8:	4c 8d 7c 24 38       	lea    r15,[rsp+0x38]
    12cd:	0f 1f 00             	nop    DWORD PTR [rax]
    12d0:	48 8b 54 24 38       	mov    rdx,QWORD PTR [rsp+0x38]
    12d5:	48 85 d2             	test   rdx,rdx
    12d8:	74 5e                	je     1338 <___main+0x148>
    12da:	48 89 df             	mov    rdi,rbx
    12dd:	48 8d 74 24 30       	lea    rsi,[rsp+0x30]
    12e2:	31 c0                	xor    eax,eax
    12e4:	ff 13                	call   QWORD PTR [rbx]
    12e6:	48 8b 7c 24 30       	mov    rdi,QWORD PTR [rsp+0x30]
    12eb:	48 8d 74 24 20       	lea    rsi,[rsp+0x20]
    12f0:	44 89 e2             	mov    edx,r12d
    12f3:	4c 89 e9             	mov    rcx,r13
    12f6:	31 c0                	xor    eax,eax
    12f8:	ff 17                	call   QWORD PTR [rdi]
    12fa:	8b 54 24 20          	mov    edx,DWORD PTR [rsp+0x20]
    12fe:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
    1303:	48 8d 3d be 6a 00 00 	lea    rdi,[rip+0x6abe]        # 7dc8 <___main._blacken$0$>
    130a:	48 89 ee             	mov    rsi,rbp
    130d:	e8 ee 05 00 00       	call   1900 <_blacken$0>
    1312:	44 8b 64 24 10       	mov    r12d,DWORD PTR [rsp+0x10]
    1317:	4c 8b 6c 24 18       	mov    r13,QWORD PTR [rsp+0x18]
    131c:	4c 89 f7             	mov    rdi,r14
    131f:	4c 89 fe             	mov    rsi,r15
    1322:	31 c0                	xor    eax,eax
    1324:	e8 57 fd ff ff       	call   1080 <__isoc99_scanf@plt>
    1329:	83 f8 01             	cmp    eax,0x1
    132c:	74 a2                	je     12d0 <___main+0xe0>
    132e:	bf 01 00 00 00       	mov    edi,0x1
    1333:	e8 58 fd ff ff       	call   1090 <exit@plt>
    1338:	48 8d 3d 99 6a 00 00 	lea    rdi,[rip+0x6a99]        # 7dd8 <___main._count_red$0$>
    133f:	48 8b 74 24 08       	mov    rsi,QWORD PTR [rsp+0x8]
    1344:	44 89 e2             	mov    edx,r12d
    1347:	4c 89 e9             	mov    rcx,r13
    134a:	e8 f1 19 00 00       	call   2d40 <_count_red$0>
    134f:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    1356:	00 00 
    1358:	48 3b 44 24 40       	cmp    rax,QWORD PTR [rsp+0x40]
    135d:	75 0f                	jne    136e <___main+0x17e>
    135f:	48 83 c4 48          	add    rsp,0x48
    1363:	5b                   	pop    rbx
    1364:	41 5c                	pop    r12
    1366:	41 5d                	pop    r13
    1368:	41 5e                	pop    r14
    136a:	41 5f                	pop    r15
    136c:	5d                   	pop    rbp
    136d:	c3                   	ret    
    136e:	e8 bd fc ff ff       	call   1030 <__stack_chk_fail@plt>
    1373:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    137a:	00 00 00 
    137d:	0f 1f 00             	nop    DWORD PTR [rax]

0000000000001380 <_Red$0>:
    1380:	41 56                	push   r14
    1382:	53                   	push   rbx
    1383:	50                   	push   rax
    1384:	48 89 d3             	mov    rbx,rdx
    1387:	49 89 f6             	mov    r14,rsi
    138a:	bf 20 00 00 00       	mov    edi,0x20
    138f:	e8 dc fc ff ff       	call   1070 <malloc@plt>
    1394:	8b 0b                	mov    ecx,DWORD PTR [rbx]
    1396:	48 83 f9 78          	cmp    rcx,0x78
    139a:	0f 87 1e 05 00 00    	ja     18be <_Red$0+0x53e>
    13a0:	48 8d 15 5d 2c 00 00 	lea    rdx,[rip+0x2c5d]        # 4004 <_IO_stdin_used+0x4>
    13a7:	48 63 0c 8a          	movsxd rcx,DWORD PTR [rdx+rcx*4]
    13ab:	48 01 d1             	add    rcx,rdx
    13ae:	ff e1                	jmp    rcx
    13b0:	c7 00 00 00 00 00    	mov    DWORD PTR [rax],0x0
    13b6:	e9 f3 04 00 00       	jmp    18ae <_Red$0+0x52e>
    13bb:	c7 00 01 00 00 00    	mov    DWORD PTR [rax],0x1
    13c1:	e9 e8 04 00 00       	jmp    18ae <_Red$0+0x52e>
    13c6:	c7 00 02 00 00 00    	mov    DWORD PTR [rax],0x2
    13cc:	e9 dd 04 00 00       	jmp    18ae <_Red$0+0x52e>
    13d1:	c7 00 03 00 00 00    	mov    DWORD PTR [rax],0x3
    13d7:	e9 d2 04 00 00       	jmp    18ae <_Red$0+0x52e>
    13dc:	c7 00 04 00 00 00    	mov    DWORD PTR [rax],0x4
    13e2:	e9 c7 04 00 00       	jmp    18ae <_Red$0+0x52e>
    13e7:	c7 00 05 00 00 00    	mov    DWORD PTR [rax],0x5
    13ed:	e9 bc 04 00 00       	jmp    18ae <_Red$0+0x52e>
    13f2:	c7 00 06 00 00 00    	mov    DWORD PTR [rax],0x6
    13f8:	e9 b1 04 00 00       	jmp    18ae <_Red$0+0x52e>
    13fd:	c7 00 07 00 00 00    	mov    DWORD PTR [rax],0x7
    1403:	e9 a6 04 00 00       	jmp    18ae <_Red$0+0x52e>
    1408:	c7 00 08 00 00 00    	mov    DWORD PTR [rax],0x8
    140e:	e9 9b 04 00 00       	jmp    18ae <_Red$0+0x52e>
    1413:	c7 00 09 00 00 00    	mov    DWORD PTR [rax],0x9
    1419:	e9 90 04 00 00       	jmp    18ae <_Red$0+0x52e>
    141e:	c7 00 0a 00 00 00    	mov    DWORD PTR [rax],0xa
    1424:	e9 85 04 00 00       	jmp    18ae <_Red$0+0x52e>
    1429:	c7 00 0b 00 00 00    	mov    DWORD PTR [rax],0xb
    142f:	e9 7a 04 00 00       	jmp    18ae <_Red$0+0x52e>
    1434:	c7 00 0c 00 00 00    	mov    DWORD PTR [rax],0xc
    143a:	e9 6f 04 00 00       	jmp    18ae <_Red$0+0x52e>
    143f:	c7 00 0d 00 00 00    	mov    DWORD PTR [rax],0xd
    1445:	e9 64 04 00 00       	jmp    18ae <_Red$0+0x52e>
    144a:	c7 00 0e 00 00 00    	mov    DWORD PTR [rax],0xe
    1450:	e9 59 04 00 00       	jmp    18ae <_Red$0+0x52e>
    1455:	c7 00 0f 00 00 00    	mov    DWORD PTR [rax],0xf
    145b:	e9 4e 04 00 00       	jmp    18ae <_Red$0+0x52e>
    1460:	c7 00 10 00 00 00    	mov    DWORD PTR [rax],0x10
    1466:	e9 43 04 00 00       	jmp    18ae <_Red$0+0x52e>
    146b:	c7 00 11 00 00 00    	mov    DWORD PTR [rax],0x11
    1471:	e9 38 04 00 00       	jmp    18ae <_Red$0+0x52e>
    1476:	c7 00 12 00 00 00    	mov    DWORD PTR [rax],0x12
    147c:	e9 2d 04 00 00       	jmp    18ae <_Red$0+0x52e>
    1481:	c7 00 13 00 00 00    	mov    DWORD PTR [rax],0x13
    1487:	e9 22 04 00 00       	jmp    18ae <_Red$0+0x52e>
    148c:	c7 00 14 00 00 00    	mov    DWORD PTR [rax],0x14
    1492:	e9 17 04 00 00       	jmp    18ae <_Red$0+0x52e>
    1497:	c7 00 15 00 00 00    	mov    DWORD PTR [rax],0x15
    149d:	e9 0c 04 00 00       	jmp    18ae <_Red$0+0x52e>
    14a2:	c7 00 16 00 00 00    	mov    DWORD PTR [rax],0x16
    14a8:	e9 01 04 00 00       	jmp    18ae <_Red$0+0x52e>
    14ad:	c7 00 17 00 00 00    	mov    DWORD PTR [rax],0x17
    14b3:	e9 f6 03 00 00       	jmp    18ae <_Red$0+0x52e>
    14b8:	c7 00 18 00 00 00    	mov    DWORD PTR [rax],0x18
    14be:	e9 eb 03 00 00       	jmp    18ae <_Red$0+0x52e>
    14c3:	c7 00 19 00 00 00    	mov    DWORD PTR [rax],0x19
    14c9:	e9 e0 03 00 00       	jmp    18ae <_Red$0+0x52e>
    14ce:	c7 00 1a 00 00 00    	mov    DWORD PTR [rax],0x1a
    14d4:	e9 d5 03 00 00       	jmp    18ae <_Red$0+0x52e>
    14d9:	c7 00 1b 00 00 00    	mov    DWORD PTR [rax],0x1b
    14df:	e9 ca 03 00 00       	jmp    18ae <_Red$0+0x52e>
    14e4:	c7 00 1c 00 00 00    	mov    DWORD PTR [rax],0x1c
    14ea:	e9 bf 03 00 00       	jmp    18ae <_Red$0+0x52e>
    14ef:	c7 00 1d 00 00 00    	mov    DWORD PTR [rax],0x1d
    14f5:	e9 b4 03 00 00       	jmp    18ae <_Red$0+0x52e>
    14fa:	c7 00 1e 00 00 00    	mov    DWORD PTR [rax],0x1e
    1500:	e9 a9 03 00 00       	jmp    18ae <_Red$0+0x52e>
    1505:	c7 00 1f 00 00 00    	mov    DWORD PTR [rax],0x1f
    150b:	e9 9e 03 00 00       	jmp    18ae <_Red$0+0x52e>
    1510:	c7 00 20 00 00 00    	mov    DWORD PTR [rax],0x20
    1516:	e9 93 03 00 00       	jmp    18ae <_Red$0+0x52e>
    151b:	c7 00 21 00 00 00    	mov    DWORD PTR [rax],0x21
    1521:	e9 88 03 00 00       	jmp    18ae <_Red$0+0x52e>
    1526:	c7 00 22 00 00 00    	mov    DWORD PTR [rax],0x22
    152c:	e9 7d 03 00 00       	jmp    18ae <_Red$0+0x52e>
    1531:	c7 00 23 00 00 00    	mov    DWORD PTR [rax],0x23
    1537:	e9 72 03 00 00       	jmp    18ae <_Red$0+0x52e>
    153c:	c7 00 24 00 00 00    	mov    DWORD PTR [rax],0x24
    1542:	e9 67 03 00 00       	jmp    18ae <_Red$0+0x52e>
    1547:	c7 00 25 00 00 00    	mov    DWORD PTR [rax],0x25
    154d:	e9 5c 03 00 00       	jmp    18ae <_Red$0+0x52e>
    1552:	c7 00 26 00 00 00    	mov    DWORD PTR [rax],0x26
    1558:	e9 51 03 00 00       	jmp    18ae <_Red$0+0x52e>
    155d:	c7 00 27 00 00 00    	mov    DWORD PTR [rax],0x27
    1563:	e9 46 03 00 00       	jmp    18ae <_Red$0+0x52e>
    1568:	c7 00 28 00 00 00    	mov    DWORD PTR [rax],0x28
    156e:	e9 3b 03 00 00       	jmp    18ae <_Red$0+0x52e>
    1573:	c7 00 29 00 00 00    	mov    DWORD PTR [rax],0x29
    1579:	e9 30 03 00 00       	jmp    18ae <_Red$0+0x52e>
    157e:	c7 00 2a 00 00 00    	mov    DWORD PTR [rax],0x2a
    1584:	e9 25 03 00 00       	jmp    18ae <_Red$0+0x52e>
    1589:	c7 00 2b 00 00 00    	mov    DWORD PTR [rax],0x2b
    158f:	e9 1a 03 00 00       	jmp    18ae <_Red$0+0x52e>
    1594:	c7 00 2c 00 00 00    	mov    DWORD PTR [rax],0x2c
    159a:	e9 0f 03 00 00       	jmp    18ae <_Red$0+0x52e>
    159f:	c7 00 2d 00 00 00    	mov    DWORD PTR [rax],0x2d
    15a5:	e9 04 03 00 00       	jmp    18ae <_Red$0+0x52e>
    15aa:	c7 00 2e 00 00 00    	mov    DWORD PTR [rax],0x2e
    15b0:	e9 f9 02 00 00       	jmp    18ae <_Red$0+0x52e>
    15b5:	c7 00 2f 00 00 00    	mov    DWORD PTR [rax],0x2f
    15bb:	e9 ee 02 00 00       	jmp    18ae <_Red$0+0x52e>
    15c0:	c7 00 30 00 00 00    	mov    DWORD PTR [rax],0x30
    15c6:	e9 e3 02 00 00       	jmp    18ae <_Red$0+0x52e>
    15cb:	c7 00 31 00 00 00    	mov    DWORD PTR [rax],0x31
    15d1:	e9 d8 02 00 00       	jmp    18ae <_Red$0+0x52e>
    15d6:	c7 00 32 00 00 00    	mov    DWORD PTR [rax],0x32
    15dc:	e9 cd 02 00 00       	jmp    18ae <_Red$0+0x52e>
    15e1:	c7 00 33 00 00 00    	mov    DWORD PTR [rax],0x33
    15e7:	e9 c2 02 00 00       	jmp    18ae <_Red$0+0x52e>
    15ec:	c7 00 34 00 00 00    	mov    DWORD PTR [rax],0x34
    15f2:	e9 b7 02 00 00       	jmp    18ae <_Red$0+0x52e>
    15f7:	c7 00 35 00 00 00    	mov    DWORD PTR [rax],0x35
    15fd:	e9 ac 02 00 00       	jmp    18ae <_Red$0+0x52e>
    1602:	c7 00 36 00 00 00    	mov    DWORD PTR [rax],0x36
    1608:	e9 a1 02 00 00       	jmp    18ae <_Red$0+0x52e>
    160d:	c7 00 37 00 00 00    	mov    DWORD PTR [rax],0x37
    1613:	e9 96 02 00 00       	jmp    18ae <_Red$0+0x52e>
    1618:	c7 00 38 00 00 00    	mov    DWORD PTR [rax],0x38
    161e:	e9 8b 02 00 00       	jmp    18ae <_Red$0+0x52e>
    1623:	c7 00 39 00 00 00    	mov    DWORD PTR [rax],0x39
    1629:	e9 80 02 00 00       	jmp    18ae <_Red$0+0x52e>
    162e:	c7 00 3a 00 00 00    	mov    DWORD PTR [rax],0x3a
    1634:	e9 75 02 00 00       	jmp    18ae <_Red$0+0x52e>
    1639:	c7 00 3b 00 00 00    	mov    DWORD PTR [rax],0x3b
    163f:	e9 6a 02 00 00       	jmp    18ae <_Red$0+0x52e>
    1644:	c7 00 3c 00 00 00    	mov    DWORD PTR [rax],0x3c
    164a:	e9 5f 02 00 00       	jmp    18ae <_Red$0+0x52e>
    164f:	c7 00 3d 00 00 00    	mov    DWORD PTR [rax],0x3d
    1655:	e9 54 02 00 00       	jmp    18ae <_Red$0+0x52e>
    165a:	c7 00 3e 00 00 00    	mov    DWORD PTR [rax],0x3e
    1660:	e9 49 02 00 00       	jmp    18ae <_Red$0+0x52e>
    1665:	c7 00 3f 00 00 00    	mov    DWORD PTR [rax],0x3f
    166b:	e9 3e 02 00 00       	jmp    18ae <_Red$0+0x52e>
    1670:	c7 00 40 00 00 00    	mov    DWORD PTR [rax],0x40
    1676:	e9 33 02 00 00       	jmp    18ae <_Red$0+0x52e>
    167b:	c7 00 41 00 00 00    	mov    DWORD PTR [rax],0x41
    1681:	e9 28 02 00 00       	jmp    18ae <_Red$0+0x52e>
    1686:	c7 00 42 00 00 00    	mov    DWORD PTR [rax],0x42
    168c:	e9 1d 02 00 00       	jmp    18ae <_Red$0+0x52e>
    1691:	c7 00 43 00 00 00    	mov    DWORD PTR [rax],0x43
    1697:	e9 12 02 00 00       	jmp    18ae <_Red$0+0x52e>
    169c:	c7 00 44 00 00 00    	mov    DWORD PTR [rax],0x44
    16a2:	e9 07 02 00 00       	jmp    18ae <_Red$0+0x52e>
    16a7:	c7 00 45 00 00 00    	mov    DWORD PTR [rax],0x45
    16ad:	e9 fc 01 00 00       	jmp    18ae <_Red$0+0x52e>
    16b2:	c7 00 46 00 00 00    	mov    DWORD PTR [rax],0x46
    16b8:	e9 f1 01 00 00       	jmp    18ae <_Red$0+0x52e>
    16bd:	c7 00 47 00 00 00    	mov    DWORD PTR [rax],0x47
    16c3:	e9 e6 01 00 00       	jmp    18ae <_Red$0+0x52e>
    16c8:	c7 00 48 00 00 00    	mov    DWORD PTR [rax],0x48
    16ce:	e9 db 01 00 00       	jmp    18ae <_Red$0+0x52e>
    16d3:	c7 00 49 00 00 00    	mov    DWORD PTR [rax],0x49
    16d9:	e9 d0 01 00 00       	jmp    18ae <_Red$0+0x52e>
    16de:	c7 00 4a 00 00 00    	mov    DWORD PTR [rax],0x4a
    16e4:	e9 c5 01 00 00       	jmp    18ae <_Red$0+0x52e>
    16e9:	c7 00 4b 00 00 00    	mov    DWORD PTR [rax],0x4b
    16ef:	e9 ba 01 00 00       	jmp    18ae <_Red$0+0x52e>
    16f4:	c7 00 4c 00 00 00    	mov    DWORD PTR [rax],0x4c
    16fa:	e9 af 01 00 00       	jmp    18ae <_Red$0+0x52e>
    16ff:	c7 00 4d 00 00 00    	mov    DWORD PTR [rax],0x4d
    1705:	e9 a4 01 00 00       	jmp    18ae <_Red$0+0x52e>
    170a:	c7 00 4e 00 00 00    	mov    DWORD PTR [rax],0x4e
    1710:	e9 99 01 00 00       	jmp    18ae <_Red$0+0x52e>
    1715:	c7 00 4f 00 00 00    	mov    DWORD PTR [rax],0x4f
    171b:	e9 8e 01 00 00       	jmp    18ae <_Red$0+0x52e>
    1720:	c7 00 50 00 00 00    	mov    DWORD PTR [rax],0x50
    1726:	e9 83 01 00 00       	jmp    18ae <_Red$0+0x52e>
    172b:	c7 00 51 00 00 00    	mov    DWORD PTR [rax],0x51
    1731:	e9 78 01 00 00       	jmp    18ae <_Red$0+0x52e>
    1736:	c7 00 52 00 00 00    	mov    DWORD PTR [rax],0x52
    173c:	e9 6d 01 00 00       	jmp    18ae <_Red$0+0x52e>
    1741:	c7 00 53 00 00 00    	mov    DWORD PTR [rax],0x53
    1747:	e9 62 01 00 00       	jmp    18ae <_Red$0+0x52e>
    174c:	c7 00 54 00 00 00    	mov    DWORD PTR [rax],0x54
    1752:	e9 57 01 00 00       	jmp    18ae <_Red$0+0x52e>
    1757:	c7 00 55 00 00 00    	mov    DWORD PTR [rax],0x55
    175d:	e9 4c 01 00 00       	jmp    18ae <_Red$0+0x52e>
    1762:	c7 00 56 00 00 00    	mov    DWORD PTR [rax],0x56
    1768:	e9 41 01 00 00       	jmp    18ae <_Red$0+0x52e>
    176d:	c7 00 57 00 00 00    	mov    DWORD PTR [rax],0x57
    1773:	e9 36 01 00 00       	jmp    18ae <_Red$0+0x52e>
    1778:	c7 00 58 00 00 00    	mov    DWORD PTR [rax],0x58
    177e:	e9 2b 01 00 00       	jmp    18ae <_Red$0+0x52e>
    1783:	c7 00 59 00 00 00    	mov    DWORD PTR [rax],0x59
    1789:	e9 20 01 00 00       	jmp    18ae <_Red$0+0x52e>
    178e:	c7 00 5a 00 00 00    	mov    DWORD PTR [rax],0x5a
    1794:	e9 15 01 00 00       	jmp    18ae <_Red$0+0x52e>
    1799:	c7 00 5b 00 00 00    	mov    DWORD PTR [rax],0x5b
    179f:	e9 0a 01 00 00       	jmp    18ae <_Red$0+0x52e>
    17a4:	c7 00 5c 00 00 00    	mov    DWORD PTR [rax],0x5c
    17aa:	e9 ff 00 00 00       	jmp    18ae <_Red$0+0x52e>
    17af:	c7 00 5d 00 00 00    	mov    DWORD PTR [rax],0x5d
    17b5:	e9 f4 00 00 00       	jmp    18ae <_Red$0+0x52e>
    17ba:	c7 00 5e 00 00 00    	mov    DWORD PTR [rax],0x5e
    17c0:	e9 e9 00 00 00       	jmp    18ae <_Red$0+0x52e>
    17c5:	c7 00 5f 00 00 00    	mov    DWORD PTR [rax],0x5f
    17cb:	e9 de 00 00 00       	jmp    18ae <_Red$0+0x52e>
    17d0:	c7 00 60 00 00 00    	mov    DWORD PTR [rax],0x60
    17d6:	e9 d3 00 00 00       	jmp    18ae <_Red$0+0x52e>
    17db:	c7 00 61 00 00 00    	mov    DWORD PTR [rax],0x61
    17e1:	e9 c8 00 00 00       	jmp    18ae <_Red$0+0x52e>
    17e6:	c7 00 62 00 00 00    	mov    DWORD PTR [rax],0x62
    17ec:	e9 bd 00 00 00       	jmp    18ae <_Red$0+0x52e>
    17f1:	c7 00 63 00 00 00    	mov    DWORD PTR [rax],0x63
    17f7:	e9 b2 00 00 00       	jmp    18ae <_Red$0+0x52e>
    17fc:	c7 00 64 00 00 00    	mov    DWORD PTR [rax],0x64
    1802:	e9 a7 00 00 00       	jmp    18ae <_Red$0+0x52e>
    1807:	c7 00 65 00 00 00    	mov    DWORD PTR [rax],0x65
    180d:	e9 9c 00 00 00       	jmp    18ae <_Red$0+0x52e>
    1812:	c7 00 66 00 00 00    	mov    DWORD PTR [rax],0x66
    1818:	e9 91 00 00 00       	jmp    18ae <_Red$0+0x52e>
    181d:	c7 00 67 00 00 00    	mov    DWORD PTR [rax],0x67
    1823:	e9 86 00 00 00       	jmp    18ae <_Red$0+0x52e>
    1828:	c7 00 68 00 00 00    	mov    DWORD PTR [rax],0x68
    182e:	eb 7e                	jmp    18ae <_Red$0+0x52e>
    1830:	c7 00 69 00 00 00    	mov    DWORD PTR [rax],0x69
    1836:	eb 76                	jmp    18ae <_Red$0+0x52e>
    1838:	c7 00 6a 00 00 00    	mov    DWORD PTR [rax],0x6a
    183e:	eb 6e                	jmp    18ae <_Red$0+0x52e>
    1840:	c7 00 6b 00 00 00    	mov    DWORD PTR [rax],0x6b
    1846:	eb 66                	jmp    18ae <_Red$0+0x52e>
    1848:	c7 00 6c 00 00 00    	mov    DWORD PTR [rax],0x6c
    184e:	eb 5e                	jmp    18ae <_Red$0+0x52e>
    1850:	c7 00 6d 00 00 00    	mov    DWORD PTR [rax],0x6d
    1856:	eb 56                	jmp    18ae <_Red$0+0x52e>
    1858:	c7 00 6e 00 00 00    	mov    DWORD PTR [rax],0x6e
    185e:	eb 4e                	jmp    18ae <_Red$0+0x52e>
    1860:	c7 00 6f 00 00 00    	mov    DWORD PTR [rax],0x6f
    1866:	eb 46                	jmp    18ae <_Red$0+0x52e>
    1868:	c7 00 70 00 00 00    	mov    DWORD PTR [rax],0x70
    186e:	eb 3e                	jmp    18ae <_Red$0+0x52e>
    1870:	c7 00 71 00 00 00    	mov    DWORD PTR [rax],0x71
    1876:	eb 36                	jmp    18ae <_Red$0+0x52e>
    1878:	c7 00 72 00 00 00    	mov    DWORD PTR [rax],0x72
    187e:	eb 2e                	jmp    18ae <_Red$0+0x52e>
    1880:	c7 00 73 00 00 00    	mov    DWORD PTR [rax],0x73
    1886:	eb 26                	jmp    18ae <_Red$0+0x52e>
    1888:	c7 00 74 00 00 00    	mov    DWORD PTR [rax],0x74
    188e:	eb 1e                	jmp    18ae <_Red$0+0x52e>
    1890:	c7 00 75 00 00 00    	mov    DWORD PTR [rax],0x75
    1896:	eb 16                	jmp    18ae <_Red$0+0x52e>
    1898:	c7 00 76 00 00 00    	mov    DWORD PTR [rax],0x76
    189e:	eb 0e                	jmp    18ae <_Red$0+0x52e>
    18a0:	c7 00 77 00 00 00    	mov    DWORD PTR [rax],0x77
    18a6:	eb 06                	jmp    18ae <_Red$0+0x52e>
    18a8:	c7 00 78 00 00 00    	mov    DWORD PTR [rax],0x78
    18ae:	0f 10 43 08          	movups xmm0,XMMWORD PTR [rbx+0x8]
    18b2:	0f 11 40 08          	movups XMMWORD PTR [rax+0x8],xmm0
    18b6:	48 8b 4b 18          	mov    rcx,QWORD PTR [rbx+0x18]
    18ba:	48 89 48 18          	mov    QWORD PTR [rax+0x18],rcx
    18be:	48 63 08             	movsxd rcx,DWORD PTR [rax]
    18c1:	48 83 f9 78          	cmp    rcx,0x78
    18c5:	77 11                	ja     18d8 <_Red$0+0x558>
    18c7:	48 8d 15 1e 47 00 00 	lea    rdx,[rip+0x471e]        # 5fec <_IO_stdin_used+0x1fec>
    18ce:	8b 0c 8a             	mov    ecx,DWORD PTR [rdx+rcx*4]
    18d1:	41 89 0e             	mov    DWORD PTR [r14],ecx
    18d4:	49 89 46 08          	mov    QWORD PTR [r14+0x8],rax
    18d8:	48 83 c4 08          	add    rsp,0x8
    18dc:	5b                   	pop    rbx
    18dd:	41 5e                	pop    r14
    18df:	c3                   	ret    

00000000000018e0 <_Blk$0>:
    18e0:	53                   	push   rbx
    18e1:	48 89 f3             	mov    rbx,rsi
    18e4:	bf 20 00 00 00       	mov    edi,0x20
    18e9:	e8 82 f7 ff ff       	call   1070 <malloc@plt>
    18ee:	c7 03 09 00 00 00    	mov    DWORD PTR [rbx],0x9
    18f4:	48 89 43 08          	mov    QWORD PTR [rbx+0x8],rax
    18f8:	5b                   	pop    rbx
    18f9:	c3                   	ret    
    18fa:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

0000000000001900 <_blacken$0>:
    1900:	50                   	push   rax
    1901:	8d 42 f7             	lea    eax,[rdx-0x9]
    1904:	83 f8 01             	cmp    eax,0x1
    1907:	77 08                	ja     1911 <_blacken$0+0x11>
    1909:	89 16                	mov    DWORD PTR [rsi],edx
    190b:	48 89 4e 08          	mov    QWORD PTR [rsi+0x8],rcx
    190f:	eb 08                	jmp    1919 <_blacken$0+0x19>
    1911:	8b 01                	mov    eax,DWORD PTR [rcx]
    1913:	48 83 f8 78          	cmp    rax,0x78
    1917:	76 02                	jbe    191b <_blacken$0+0x1b>
    1919:	58                   	pop    rax
    191a:	c3                   	ret    
    191b:	48 8d 0d c6 28 00 00 	lea    rcx,[rip+0x28c6]        # 41e8 <_IO_stdin_used+0x1e8>
    1922:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1926:	48 01 c8             	add    rax,rcx
    1929:	ff e0                	jmp    rax
    192b:	bf 01 00 00 00       	mov    edi,0x1
    1930:	e8 5b f7 ff ff       	call   1090 <exit@plt>
    1935:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    193c:	00 00 00 
    193f:	90                   	nop

0000000000001940 <_get_value$0>:
    1940:	50                   	push   rax
    1941:	83 fa 0a             	cmp    edx,0xa
    1944:	73 09                	jae    194f <_get_value$0+0xf>
    1946:	48 8b 41 18          	mov    rax,QWORD PTR [rcx+0x18]
    194a:	48 89 06             	mov    QWORD PTR [rsi],rax
    194d:	58                   	pop    rax
    194e:	c3                   	ret    
    194f:	bf 01 00 00 00       	mov    edi,0x1
    1954:	e8 37 f7 ff ff       	call   1090 <exit@plt>
    1959:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001960 <_$17>:
    1960:	41 56                	push   r14
    1962:	53                   	push   rbx
    1963:	48 83 ec 18          	sub    rsp,0x18
    1967:	48 89 d1             	mov    rcx,rdx
    196a:	49 89 f6             	mov    r14,rsi
    196d:	48 89 fb             	mov    rbx,rdi
    1970:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    1977:	00 00 
    1979:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
    197e:	83 7f 18 09          	cmp    DWORD PTR [rdi+0x18],0x9
    1982:	73 38                	jae    19bc <_$17+0x5c>
    1984:	48 8b 53 20          	mov    rdx,QWORD PTR [rbx+0x20]
    1988:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
    198d:	48 89 cf             	mov    rdi,rcx
    1990:	31 c0                	xor    eax,eax
    1992:	ff 11                	call   QWORD PTR [rcx]
    1994:	48 8b 7b 10          	mov    rdi,QWORD PTR [rbx+0x10]
    1998:	48 8b 54 24 08       	mov    rdx,QWORD PTR [rsp+0x8]
    199d:	4c 89 f6             	mov    rsi,r14
    19a0:	31 c0                	xor    eax,eax
    19a2:	ff 17                	call   QWORD PTR [rdi]
    19a4:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    19ab:	00 00 
    19ad:	48 3b 44 24 10       	cmp    rax,QWORD PTR [rsp+0x10]
    19b2:	75 2a                	jne    19de <_$17+0x7e>
    19b4:	48 83 c4 18          	add    rsp,0x18
    19b8:	5b                   	pop    rbx
    19b9:	41 5e                	pop    r14
    19bb:	c3                   	ret    
    19bc:	75 16                	jne    19d4 <_$17+0x74>
    19be:	48 8b 53 20          	mov    rdx,QWORD PTR [rbx+0x20]
    19c2:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
    19c7:	48 89 cf             	mov    rdi,rcx
    19ca:	31 c0                	xor    eax,eax
    19cc:	ff 11                	call   QWORD PTR [rcx]
    19ce:	48 8b 7b 08          	mov    rdi,QWORD PTR [rbx+0x8]
    19d2:	eb c4                	jmp    1998 <_$17+0x38>
    19d4:	bf 01 00 00 00       	mov    edi,0x1
    19d9:	e8 b2 f6 ff ff       	call   1090 <exit@plt>
    19de:	e8 4d f6 ff ff       	call   1030 <__stack_chk_fail@plt>
    19e3:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    19ea:	00 00 00 
    19ed:	0f 1f 00             	nop    DWORD PTR [rax]

00000000000019f0 <_map_data$0>:
    19f0:	55                   	push   rbp
    19f1:	41 57                	push   r15
    19f3:	41 56                	push   r14
    19f5:	53                   	push   rbx
    19f6:	50                   	push   rax
    19f7:	49 89 ce             	mov    r14,rcx
    19fa:	89 d5                	mov    ebp,edx
    19fc:	49 89 f7             	mov    r15,rsi
    19ff:	48 89 fb             	mov    rbx,rdi
    1a02:	bf 28 00 00 00       	mov    edi,0x28
    1a07:	e8 64 f6 ff ff       	call   1070 <malloc@plt>
    1a0c:	0f 10 43 08          	movups xmm0,XMMWORD PTR [rbx+0x8]
    1a10:	48 8d 0d 49 ff ff ff 	lea    rcx,[rip+0xffffffffffffff49]        # 1960 <_$17>
    1a17:	48 89 08             	mov    QWORD PTR [rax],rcx
    1a1a:	0f 11 40 08          	movups XMMWORD PTR [rax+0x8],xmm0
    1a1e:	89 68 18             	mov    DWORD PTR [rax+0x18],ebp
    1a21:	4c 89 70 20          	mov    QWORD PTR [rax+0x20],r14
    1a25:	49 89 07             	mov    QWORD PTR [r15],rax
    1a28:	48 83 c4 08          	add    rsp,0x8
    1a2c:	5b                   	pop    rbx
    1a2d:	41 5e                	pop    r14
    1a2f:	41 5f                	pop    r15
    1a31:	5d                   	pop    rbp
    1a32:	c3                   	ret    
    1a33:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    1a3a:	00 00 00 
    1a3d:	0f 1f 00             	nop    DWORD PTR [rax]

0000000000001a40 <_balance$0>:
    1a40:	55                   	push   rbp
    1a41:	41 57                	push   r15
    1a43:	41 56                	push   r14
    1a45:	41 55                	push   r13
    1a47:	41 54                	push   r12
    1a49:	53                   	push   rbx
    1a4a:	48 83 ec 28          	sub    rsp,0x28
    1a4e:	49 89 cd             	mov    r13,rcx
    1a51:	49 89 f7             	mov    r15,rsi
    1a54:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    1a5b:	00 00 
    1a5d:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
    1a62:	83 fa 09             	cmp    edx,0x9
    1a65:	75 37                	jne    1a9e <_balance$0+0x5e>
    1a67:	49 89 fe             	mov    r14,rdi
    1a6a:	41 8b 4d 00          	mov    ecx,DWORD PTR [r13+0x0]
    1a6e:	48 8d 05 57 29 00 00 	lea    rax,[rip+0x2957]        # 43cc <_IO_stdin_used+0x3cc>
    1a75:	48 63 14 88          	movsxd rdx,DWORD PTR [rax+rcx*4]
    1a79:	48 01 c2             	add    rdx,rax
    1a7c:	ff e2                	jmp    rdx
    1a7e:	41 c7 07 09 00 00 00 	mov    DWORD PTR [r15],0x9
    1a85:	4d 89 6f 08          	mov    QWORD PTR [r15+0x8],r13
    1a89:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    1a90:	00 00 
    1a92:	48 3b 44 24 20       	cmp    rax,QWORD PTR [rsp+0x20]
    1a97:	74 20                	je     1ab9 <_balance$0+0x79>
    1a99:	e9 54 0f 00 00       	jmp    29f2 <_balance$0+0xfb2>
    1a9e:	41 89 17             	mov    DWORD PTR [r15],edx
    1aa1:	4d 89 6f 08          	mov    QWORD PTR [r15+0x8],r13
    1aa5:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    1aac:	00 00 
    1aae:	48 3b 44 24 20       	cmp    rax,QWORD PTR [rsp+0x20]
    1ab3:	0f 85 39 0f 00 00    	jne    29f2 <_balance$0+0xfb2>
    1ab9:	48 83 c4 28          	add    rsp,0x28
    1abd:	5b                   	pop    rbx
    1abe:	41 5c                	pop    r12
    1ac0:	41 5d                	pop    r13
    1ac2:	41 5e                	pop    r14
    1ac4:	41 5f                	pop    r15
    1ac6:	5d                   	pop    rbp
    1ac7:	c3                   	ret    
    1ac8:	49 8b 45 08          	mov    rax,QWORD PTR [r13+0x8]
    1acc:	8b 08                	mov    ecx,DWORD PTR [rax]
    1ace:	83 f9 09             	cmp    ecx,0x9
    1ad1:	0f 83 20 0f 00 00    	jae    29f7 <_balance$0+0xfb7>
    1ad7:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
    1adb:	48 8b 49 10          	mov    rcx,QWORD PTR [rcx+0x10]
    1adf:	8b 09                	mov    ecx,DWORD PTR [rcx]
    1ae1:	83 f9 09             	cmp    ecx,0x9
    1ae4:	0f 83 0d 0f 00 00    	jae    29f7 <_balance$0+0xfb7>
    1aea:	8b 08                	mov    ecx,DWORD PTR [rax]
    1aec:	83 f9 09             	cmp    ecx,0x9
    1aef:	0f 83 02 0f 00 00    	jae    29f7 <_balance$0+0xfb7>
    1af5:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
    1af9:	48 8b 49 10          	mov    rcx,QWORD PTR [rcx+0x10]
    1afd:	8b 11                	mov    edx,DWORD PTR [rcx]
    1aff:	83 fa 09             	cmp    edx,0x9
    1b02:	0f 83 f9 0e 00 00    	jae    2a01 <_balance$0+0xfc1>
    1b08:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    1b0c:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    1b10:	8b 18                	mov    ebx,DWORD PTR [rax]
    1b12:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
    1b16:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    1b1a:	8b 28                	mov    ebp,DWORD PTR [rax]
    1b1c:	bf 20 00 00 00       	mov    edi,0x20
    1b21:	e8 4a f5 ff ff       	call   1070 <malloc@plt>
    1b26:	48 83 fb 0a          	cmp    rbx,0xa
    1b2a:	0f 87 dc 02 00 00    	ja     1e0c <_balance$0+0x3cc>
    1b30:	48 8d 0d 79 2a 00 00 	lea    rcx,[rip+0x2a79]        # 45b0 <_IO_stdin_used+0x5b0>
    1b37:	48 63 14 99          	movsxd rdx,DWORD PTR [rcx+rbx*4]
    1b3b:	48 01 ca             	add    rdx,rcx
    1b3e:	ff e2                	jmp    rdx
    1b40:	83 fd 0a             	cmp    ebp,0xa
    1b43:	0f 87 c3 02 00 00    	ja     1e0c <_balance$0+0x3cc>
    1b49:	89 e8                	mov    eax,ebp
    1b4b:	48 8d 0d 42 2c 00 00 	lea    rcx,[rip+0x2c42]        # 4794 <_IO_stdin_used+0x794>
    1b52:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1b56:	48 01 c8             	add    rax,rcx
    1b59:	ff e0                	jmp    rax
    1b5b:	49 8b 45 10          	mov    rax,QWORD PTR [r13+0x10]
    1b5f:	8b 10                	mov    edx,DWORD PTR [rax]
    1b61:	83 fa 09             	cmp    edx,0x9
    1b64:	0f 83 97 0e 00 00    	jae    2a01 <_balance$0+0xfc1>
    1b6a:	49 8b 55 08          	mov    rdx,QWORD PTR [r13+0x8]
    1b6e:	49 83 c5 10          	add    r13,0x10
    1b72:	44 8b 22             	mov    r12d,DWORD PTR [rdx]
    1b75:	83 c1 fc             	add    ecx,0xfffffffc
    1b78:	48 8d 15 61 30 00 00 	lea    rdx,[rip+0x3061]        # 4be0 <_IO_stdin_used+0xbe0>
    1b7f:	48 63 0c 8a          	movsxd rcx,DWORD PTR [rdx+rcx*4]
    1b83:	48 01 d1             	add    rcx,rdx
    1b86:	ff e1                	jmp    rcx
    1b88:	48 89 c1             	mov    rcx,rax
    1b8b:	48 83 c1 08          	add    rcx,0x8
    1b8f:	8b 00                	mov    eax,DWORD PTR [rax]
    1b91:	83 f8 09             	cmp    eax,0x9
    1b94:	0f 83 8f 09 00 00    	jae    2529 <_balance$0+0xae9>
    1b9a:	48 8b 01             	mov    rax,QWORD PTR [rcx]
    1b9d:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    1ba1:	8b 28                	mov    ebp,DWORD PTR [rax]
    1ba3:	bf 20 00 00 00       	mov    edi,0x20
    1ba8:	e8 c3 f4 ff ff       	call   1070 <malloc@plt>
    1bad:	41 83 fc 0a          	cmp    r12d,0xa
    1bb1:	0f 87 1b 06 00 00    	ja     21d2 <_balance$0+0x792>
    1bb7:	44 89 e1             	mov    ecx,r12d
    1bba:	48 8d 15 c7 31 00 00 	lea    rdx,[rip+0x31c7]        # 4d88 <_IO_stdin_used+0xd88>
    1bc1:	48 63 0c 8a          	movsxd rcx,DWORD PTR [rdx+rcx*4]
    1bc5:	48 01 d1             	add    rcx,rdx
    1bc8:	ff e1                	jmp    rcx
    1bca:	83 fd 0a             	cmp    ebp,0xa
    1bcd:	0f 87 ff 05 00 00    	ja     21d2 <_balance$0+0x792>
    1bd3:	89 e8                	mov    eax,ebp
    1bd5:	48 8d 0d 90 33 00 00 	lea    rcx,[rip+0x3390]        # 4f6c <_IO_stdin_used+0xf6c>
    1bdc:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1be0:	48 01 c8             	add    rax,rcx
    1be3:	ff e0                	jmp    rax
    1be5:	49 8b 45 10          	mov    rax,QWORD PTR [r13+0x10]
    1be9:	8b 08                	mov    ecx,DWORD PTR [rax]
    1beb:	83 f9 09             	cmp    ecx,0x9
    1bee:	0f 83 03 0e 00 00    	jae    29f7 <_balance$0+0xfb7>
    1bf4:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    1bf8:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    1bfc:	8b 00                	mov    eax,DWORD PTR [rax]
    1bfe:	83 f8 09             	cmp    eax,0x9
    1c01:	0f 83 22 09 00 00    	jae    2529 <_balance$0+0xae9>
    1c07:	49 8b 45 10          	mov    rax,QWORD PTR [r13+0x10]
    1c0b:	8b 08                	mov    ecx,DWORD PTR [rax]
    1c0d:	83 f9 09             	cmp    ecx,0x9
    1c10:	0f 83 e1 0d 00 00    	jae    29f7 <_balance$0+0xfb7>
    1c16:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    1c1a:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    1c1e:	8b 08                	mov    ecx,DWORD PTR [rax]
    1c20:	83 f9 09             	cmp    ecx,0x9
    1c23:	0f 83 ce 0d 00 00    	jae    29f7 <_balance$0+0xfb7>
    1c29:	49 8b 4d 08          	mov    rcx,QWORD PTR [r13+0x8]
    1c2d:	8b 19                	mov    ebx,DWORD PTR [rcx]
    1c2f:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    1c33:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    1c37:	8b 28                	mov    ebp,DWORD PTR [rax]
    1c39:	bf 20 00 00 00       	mov    edi,0x20
    1c3e:	e8 2d f4 ff ff       	call   1070 <malloc@plt>
    1c43:	83 fb 0a             	cmp    ebx,0xa
    1c46:	0f 87 0d 08 00 00    	ja     2459 <_balance$0+0xa19>
    1c4c:	89 d9                	mov    ecx,ebx
    1c4e:	48 8d 15 53 35 00 00 	lea    rdx,[rip+0x3553]        # 51a8 <_IO_stdin_used+0x11a8>
    1c55:	48 63 0c 8a          	movsxd rcx,DWORD PTR [rdx+rcx*4]
    1c59:	48 01 d1             	add    rcx,rdx
    1c5c:	ff e1                	jmp    rcx
    1c5e:	83 fd 0a             	cmp    ebp,0xa
    1c61:	0f 87 f2 07 00 00    	ja     2459 <_balance$0+0xa19>
    1c67:	89 e8                	mov    eax,ebp
    1c69:	48 8d 0d 1c 37 00 00 	lea    rcx,[rip+0x371c]        # 538c <_IO_stdin_used+0x138c>
    1c70:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1c74:	48 01 c8             	add    rax,rcx
    1c77:	ff e0                	jmp    rax
    1c79:	49 8b 45 08          	mov    rax,QWORD PTR [r13+0x8]
    1c7d:	8b 08                	mov    ecx,DWORD PTR [rax]
    1c7f:	83 f9 09             	cmp    ecx,0x9
    1c82:	0f 83 86 0d 00 00    	jae    2a0e <_balance$0+0xfce>
    1c88:	8b 08                	mov    ecx,DWORD PTR [rax]
    1c8a:	83 f9 09             	cmp    ecx,0x9
    1c8d:	0f 83 7b 0d 00 00    	jae    2a0e <_balance$0+0xfce>
    1c93:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    1c97:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    1c9b:	8b 10                	mov    edx,DWORD PTR [rax]
    1c9d:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
    1ca1:	49 8b 7e 18          	mov    rdi,QWORD PTR [r14+0x18]
    1ca5:	48 8d 74 24 10       	lea    rsi,[rsp+0x10]
    1caa:	31 c0                	xor    eax,eax
    1cac:	ff 17                	call   QWORD PTR [rdi]
    1cae:	49 8b 45 08          	mov    rax,QWORD PTR [r13+0x8]
    1cb2:	8b 08                	mov    ecx,DWORD PTR [rax]
    1cb4:	83 f9 09             	cmp    ecx,0x9
    1cb7:	0f 83 51 0d 00 00    	jae    2a0e <_balance$0+0xfce>
    1cbd:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    1cc1:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
    1cc5:	8b 28                	mov    ebp,DWORD PTR [rax]
    1cc7:	49 8b 45 10          	mov    rax,QWORD PTR [r13+0x10]
    1ccb:	8b 18                	mov    ebx,DWORD PTR [rax]
    1ccd:	bf 20 00 00 00       	mov    edi,0x20
    1cd2:	e8 99 f3 ff ff       	call   1070 <malloc@plt>
    1cd7:	48 83 fd 0a          	cmp    rbp,0xa
    1cdb:	0f 87 9a 0b 00 00    	ja     287b <_balance$0+0xe3b>
    1ce1:	48 8d 0d d4 3c 00 00 	lea    rcx,[rip+0x3cd4]        # 59bc <_IO_stdin_used+0x19bc>
    1ce8:	48 63 14 a9          	movsxd rdx,DWORD PTR [rcx+rbp*4]
    1cec:	48 01 ca             	add    rdx,rcx
    1cef:	ff e2                	jmp    rdx
    1cf1:	83 fb 0a             	cmp    ebx,0xa
    1cf4:	0f 87 81 0b 00 00    	ja     287b <_balance$0+0xe3b>
    1cfa:	89 d8                	mov    eax,ebx
    1cfc:	48 8d 0d 9d 3e 00 00 	lea    rcx,[rip+0x3e9d]        # 5ba0 <_IO_stdin_used+0x1ba0>
    1d03:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1d07:	48 01 c8             	add    rax,rcx
    1d0a:	ff e0                	jmp    rax
    1d0c:	49 8b 45 00          	mov    rax,QWORD PTR [r13+0x0]
    1d10:	48 8d 48 08          	lea    rcx,[rax+0x8]
    1d14:	8b 00                	mov    eax,DWORD PTR [rax]
    1d16:	83 f8 09             	cmp    eax,0x9
    1d19:	0f 82 7b fe ff ff    	jb     1b9a <_balance$0+0x15a>
    1d1f:	e9 05 08 00 00       	jmp    2529 <_balance$0+0xae9>
    1d24:	83 fd 0a             	cmp    ebp,0xa
    1d27:	0f 87 df 00 00 00    	ja     1e0c <_balance$0+0x3cc>
    1d2d:	89 e8                	mov    eax,ebp
    1d2f:	48 8d 0d ae 29 00 00 	lea    rcx,[rip+0x29ae]        # 46e4 <_IO_stdin_used+0x6e4>
    1d36:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1d3a:	48 01 c8             	add    rax,rcx
    1d3d:	ff e0                	jmp    rax
    1d3f:	83 fd 0a             	cmp    ebp,0xa
    1d42:	0f 87 c4 00 00 00    	ja     1e0c <_balance$0+0x3cc>
    1d48:	89 e8                	mov    eax,ebp
    1d4a:	48 8d 0d b7 28 00 00 	lea    rcx,[rip+0x28b7]        # 4608 <_IO_stdin_used+0x608>
    1d51:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1d55:	48 01 c8             	add    rax,rcx
    1d58:	ff e0                	jmp    rax
    1d5a:	83 fd 0a             	cmp    ebp,0xa
    1d5d:	0f 87 a9 00 00 00    	ja     1e0c <_balance$0+0x3cc>
    1d63:	89 e8                	mov    eax,ebp
    1d65:	48 8d 0d d0 29 00 00 	lea    rcx,[rip+0x29d0]        # 473c <_IO_stdin_used+0x73c>
    1d6c:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1d70:	48 01 c8             	add    rax,rcx
    1d73:	ff e0                	jmp    rax
    1d75:	83 fd 0a             	cmp    ebp,0xa
    1d78:	0f 87 8e 00 00 00    	ja     1e0c <_balance$0+0x3cc>
    1d7e:	89 e8                	mov    eax,ebp
    1d80:	48 8d 0d 89 29 00 00 	lea    rcx,[rip+0x2989]        # 4710 <_IO_stdin_used+0x710>
    1d87:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1d8b:	48 01 c8             	add    rax,rcx
    1d8e:	ff e0                	jmp    rax
    1d90:	83 fd 0a             	cmp    ebp,0xa
    1d93:	77 77                	ja     1e0c <_balance$0+0x3cc>
    1d95:	89 e8                	mov    eax,ebp
    1d97:	48 8d 0d c2 28 00 00 	lea    rcx,[rip+0x28c2]        # 4660 <_IO_stdin_used+0x660>
    1d9e:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1da2:	48 01 c8             	add    rax,rcx
    1da5:	ff e0                	jmp    rax
    1da7:	83 fd 0a             	cmp    ebp,0xa
    1daa:	77 60                	ja     1e0c <_balance$0+0x3cc>
    1dac:	89 e8                	mov    eax,ebp
    1dae:	48 8d 0d b3 29 00 00 	lea    rcx,[rip+0x29b3]        # 4768 <_IO_stdin_used+0x768>
    1db5:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1db9:	48 01 c8             	add    rax,rcx
    1dbc:	ff e0                	jmp    rax
    1dbe:	83 fd 0a             	cmp    ebp,0xa
    1dc1:	77 49                	ja     1e0c <_balance$0+0x3cc>
    1dc3:	89 e8                	mov    eax,ebp
    1dc5:	48 8d 0d ec 28 00 00 	lea    rcx,[rip+0x28ec]        # 46b8 <_IO_stdin_used+0x6b8>
    1dcc:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1dd0:	48 01 c8             	add    rax,rcx
    1dd3:	ff e0                	jmp    rax
    1dd5:	83 fd 0a             	cmp    ebp,0xa
    1dd8:	77 32                	ja     1e0c <_balance$0+0x3cc>
    1dda:	89 e8                	mov    eax,ebp
    1ddc:	48 8d 0d a9 28 00 00 	lea    rcx,[rip+0x28a9]        # 468c <_IO_stdin_used+0x68c>
    1de3:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1de7:	48 01 c8             	add    rax,rcx
    1dea:	ff e0                	jmp    rax
    1dec:	83 fd 0a             	cmp    ebp,0xa
    1def:	77 1b                	ja     1e0c <_balance$0+0x3cc>
    1df1:	89 e8                	mov    eax,ebp
    1df3:	48 8d 0d 3a 28 00 00 	lea    rcx,[rip+0x283a]        # 4634 <_IO_stdin_used+0x634>
    1dfa:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1dfe:	48 01 c8             	add    rax,rcx
    1e01:	ff e0                	jmp    rax
    1e03:	83 fd 0a             	cmp    ebp,0xa
    1e06:	0f 86 0f 0c 00 00    	jbe    2a1b <_balance$0+0xfdb>
    1e0c:	49 8b 7e 08          	mov    rdi,QWORD PTR [r14+0x8]
    1e10:	48 8d 74 24 10       	lea    rsi,[rsp+0x10]
    1e15:	48 89 c2             	mov    rdx,rax
    1e18:	31 c0                	xor    eax,eax
    1e1a:	ff 17                	call   QWORD PTR [rdi]
    1e1c:	49 8b 45 08          	mov    rax,QWORD PTR [r13+0x8]
    1e20:	8b 08                	mov    ecx,DWORD PTR [rax]
    1e22:	83 f9 09             	cmp    ecx,0x9
    1e25:	0f 83 cc 0b 00 00    	jae    29f7 <_balance$0+0xfb7>
    1e2b:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    1e2f:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
    1e33:	8b 08                	mov    ecx,DWORD PTR [rax]
    1e35:	83 f9 09             	cmp    ecx,0x9
    1e38:	0f 83 b9 0b 00 00    	jae    29f7 <_balance$0+0xfb7>
    1e3e:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    1e42:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
    1e46:	8b 28                	mov    ebp,DWORD PTR [rax]
    1e48:	49 8b 45 10          	mov    rax,QWORD PTR [r13+0x10]
    1e4c:	8b 18                	mov    ebx,DWORD PTR [rax]
    1e4e:	bf 20 00 00 00       	mov    edi,0x20
    1e53:	e8 18 f2 ff ff       	call   1070 <malloc@plt>
    1e58:	48 83 fd 0a          	cmp    rbp,0xa
    1e5c:	0f 87 13 01 00 00    	ja     1f75 <_balance$0+0x535>
    1e62:	48 8d 0d 57 29 00 00 	lea    rcx,[rip+0x2957]        # 47c0 <_IO_stdin_used+0x7c0>
    1e69:	48 63 14 a9          	movsxd rdx,DWORD PTR [rcx+rbp*4]
    1e6d:	48 01 ca             	add    rdx,rcx
    1e70:	ff e2                	jmp    rdx
    1e72:	83 fb 0a             	cmp    ebx,0xa
    1e75:	0f 87 fa 00 00 00    	ja     1f75 <_balance$0+0x535>
    1e7b:	89 d8                	mov    eax,ebx
    1e7d:	48 8d 0d 20 2b 00 00 	lea    rcx,[rip+0x2b20]        # 49a4 <_IO_stdin_used+0x9a4>
    1e84:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1e88:	48 01 c8             	add    rax,rcx
    1e8b:	ff e0                	jmp    rax
    1e8d:	83 fb 0a             	cmp    ebx,0xa
    1e90:	0f 87 df 00 00 00    	ja     1f75 <_balance$0+0x535>
    1e96:	89 d8                	mov    eax,ebx
    1e98:	48 8d 0d 55 2a 00 00 	lea    rcx,[rip+0x2a55]        # 48f4 <_IO_stdin_used+0x8f4>
    1e9f:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1ea3:	48 01 c8             	add    rax,rcx
    1ea6:	ff e0                	jmp    rax
    1ea8:	83 fb 0a             	cmp    ebx,0xa
    1eab:	0f 87 c4 00 00 00    	ja     1f75 <_balance$0+0x535>
    1eb1:	89 d8                	mov    eax,ebx
    1eb3:	48 8d 0d 5e 29 00 00 	lea    rcx,[rip+0x295e]        # 4818 <_IO_stdin_used+0x818>
    1eba:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1ebe:	48 01 c8             	add    rax,rcx
    1ec1:	ff e0                	jmp    rax
    1ec3:	83 fb 0a             	cmp    ebx,0xa
    1ec6:	0f 87 a9 00 00 00    	ja     1f75 <_balance$0+0x535>
    1ecc:	89 d8                	mov    eax,ebx
    1ece:	48 8d 0d 77 2a 00 00 	lea    rcx,[rip+0x2a77]        # 494c <_IO_stdin_used+0x94c>
    1ed5:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1ed9:	48 01 c8             	add    rax,rcx
    1edc:	ff e0                	jmp    rax
    1ede:	83 fb 0a             	cmp    ebx,0xa
    1ee1:	0f 87 8e 00 00 00    	ja     1f75 <_balance$0+0x535>
    1ee7:	89 d8                	mov    eax,ebx
    1ee9:	48 8d 0d 30 2a 00 00 	lea    rcx,[rip+0x2a30]        # 4920 <_IO_stdin_used+0x920>
    1ef0:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1ef4:	48 01 c8             	add    rax,rcx
    1ef7:	ff e0                	jmp    rax
    1ef9:	83 fb 0a             	cmp    ebx,0xa
    1efc:	77 77                	ja     1f75 <_balance$0+0x535>
    1efe:	89 d8                	mov    eax,ebx
    1f00:	48 8d 0d 69 29 00 00 	lea    rcx,[rip+0x2969]        # 4870 <_IO_stdin_used+0x870>
    1f07:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1f0b:	48 01 c8             	add    rax,rcx
    1f0e:	ff e0                	jmp    rax
    1f10:	83 fb 0a             	cmp    ebx,0xa
    1f13:	77 60                	ja     1f75 <_balance$0+0x535>
    1f15:	89 d8                	mov    eax,ebx
    1f17:	48 8d 0d 5a 2a 00 00 	lea    rcx,[rip+0x2a5a]        # 4978 <_IO_stdin_used+0x978>
    1f1e:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1f22:	48 01 c8             	add    rax,rcx
    1f25:	ff e0                	jmp    rax
    1f27:	83 fb 0a             	cmp    ebx,0xa
    1f2a:	77 49                	ja     1f75 <_balance$0+0x535>
    1f2c:	89 d8                	mov    eax,ebx
    1f2e:	48 8d 0d 93 29 00 00 	lea    rcx,[rip+0x2993]        # 48c8 <_IO_stdin_used+0x8c8>
    1f35:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1f39:	48 01 c8             	add    rax,rcx
    1f3c:	ff e0                	jmp    rax
    1f3e:	83 fb 0a             	cmp    ebx,0xa
    1f41:	77 32                	ja     1f75 <_balance$0+0x535>
    1f43:	89 d8                	mov    eax,ebx
    1f45:	48 8d 0d 50 29 00 00 	lea    rcx,[rip+0x2950]        # 489c <_IO_stdin_used+0x89c>
    1f4c:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1f50:	48 01 c8             	add    rax,rcx
    1f53:	ff e0                	jmp    rax
    1f55:	83 fb 0a             	cmp    ebx,0xa
    1f58:	77 1b                	ja     1f75 <_balance$0+0x535>
    1f5a:	89 d8                	mov    eax,ebx
    1f5c:	48 8d 0d e1 28 00 00 	lea    rcx,[rip+0x28e1]        # 4844 <_IO_stdin_used+0x844>
    1f63:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    1f67:	48 01 c8             	add    rax,rcx
    1f6a:	ff e0                	jmp    rax
    1f6c:	83 fb 0a             	cmp    ebx,0xa
    1f6f:	0f 86 b8 0a 00 00    	jbe    2a2d <_balance$0+0xfed>
    1f75:	49 8b 7e 08          	mov    rdi,QWORD PTR [r14+0x8]
    1f79:	48 89 e6             	mov    rsi,rsp
    1f7c:	48 89 c2             	mov    rdx,rax
    1f7f:	31 c0                	xor    eax,eax
    1f81:	ff 17                	call   QWORD PTR [rdi]
    1f83:	bf 20 00 00 00       	mov    edi,0x20
    1f88:	e8 e3 f0 ff ff       	call   1070 <malloc@plt>
    1f8d:	8b 4c 24 10          	mov    ecx,DWORD PTR [rsp+0x10]
    1f91:	48 83 f9 0a          	cmp    rcx,0xa
    1f95:	0f 87 35 0a 00 00    	ja     29d0 <_balance$0+0xf90>
    1f9b:	48 8d 15 2e 2a 00 00 	lea    rdx,[rip+0x2a2e]        # 49d0 <_IO_stdin_used+0x9d0>
    1fa2:	48 63 0c 8a          	movsxd rcx,DWORD PTR [rdx+rcx*4]
    1fa6:	48 01 d1             	add    rcx,rdx
    1fa9:	ff e1                	jmp    rcx
    1fab:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    1fae:	48 83 f9 0a          	cmp    rcx,0xa
    1fb2:	0f 87 18 0a 00 00    	ja     29d0 <_balance$0+0xf90>
    1fb8:	48 8d 05 f5 2b 00 00 	lea    rax,[rip+0x2bf5]        # 4bb4 <_IO_stdin_used+0xbb4>
    1fbf:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    1fc3:	48 01 c1             	add    rcx,rax
    1fc6:	ff e1                	jmp    rcx
    1fc8:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    1fcb:	48 83 f9 0a          	cmp    rcx,0xa
    1fcf:	0f 87 fb 09 00 00    	ja     29d0 <_balance$0+0xf90>
    1fd5:	48 8d 05 28 2b 00 00 	lea    rax,[rip+0x2b28]        # 4b04 <_IO_stdin_used+0xb04>
    1fdc:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    1fe0:	48 01 c1             	add    rcx,rax
    1fe3:	ff e1                	jmp    rcx
    1fe5:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    1fe8:	48 83 f9 0a          	cmp    rcx,0xa
    1fec:	0f 87 de 09 00 00    	ja     29d0 <_balance$0+0xf90>
    1ff2:	48 8d 05 2f 2a 00 00 	lea    rax,[rip+0x2a2f]        # 4a28 <_IO_stdin_used+0xa28>
    1ff9:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    1ffd:	48 01 c1             	add    rcx,rax
    2000:	ff e1                	jmp    rcx
    2002:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2005:	48 83 f9 0a          	cmp    rcx,0xa
    2009:	0f 87 c1 09 00 00    	ja     29d0 <_balance$0+0xf90>
    200f:	48 8d 05 46 2b 00 00 	lea    rax,[rip+0x2b46]        # 4b5c <_IO_stdin_used+0xb5c>
    2016:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    201a:	48 01 c1             	add    rcx,rax
    201d:	ff e1                	jmp    rcx
    201f:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2022:	48 83 f9 0a          	cmp    rcx,0xa
    2026:	0f 87 a4 09 00 00    	ja     29d0 <_balance$0+0xf90>
    202c:	48 8d 05 fd 2a 00 00 	lea    rax,[rip+0x2afd]        # 4b30 <_IO_stdin_used+0xb30>
    2033:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2037:	48 01 c1             	add    rcx,rax
    203a:	ff e1                	jmp    rcx
    203c:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    203f:	48 83 f9 0a          	cmp    rcx,0xa
    2043:	0f 87 87 09 00 00    	ja     29d0 <_balance$0+0xf90>
    2049:	48 8d 05 38 2b 00 00 	lea    rax,[rip+0x2b38]        # 4b88 <_IO_stdin_used+0xb88>
    2050:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2054:	48 01 c1             	add    rcx,rax
    2057:	ff e1                	jmp    rcx
    2059:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    205c:	48 83 f9 0a          	cmp    rcx,0xa
    2060:	0f 87 6a 09 00 00    	ja     29d0 <_balance$0+0xf90>
    2066:	48 8d 05 13 2a 00 00 	lea    rax,[rip+0x2a13]        # 4a80 <_IO_stdin_used+0xa80>
    206d:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2071:	48 01 c1             	add    rcx,rax
    2074:	ff e1                	jmp    rcx
    2076:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2079:	48 83 f9 0a          	cmp    rcx,0xa
    207d:	0f 87 4d 09 00 00    	ja     29d0 <_balance$0+0xf90>
    2083:	48 8d 05 4e 2a 00 00 	lea    rax,[rip+0x2a4e]        # 4ad8 <_IO_stdin_used+0xad8>
    208a:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    208e:	48 01 c1             	add    rcx,rax
    2091:	ff e1                	jmp    rcx
    2093:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2096:	48 83 f9 0a          	cmp    rcx,0xa
    209a:	0f 87 30 09 00 00    	ja     29d0 <_balance$0+0xf90>
    20a0:	48 8d 05 05 2a 00 00 	lea    rax,[rip+0x2a05]        # 4aac <_IO_stdin_used+0xaac>
    20a7:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    20ab:	48 01 c1             	add    rcx,rax
    20ae:	ff e1                	jmp    rcx
    20b0:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    20b3:	48 83 f9 0a          	cmp    rcx,0xa
    20b7:	0f 87 13 09 00 00    	ja     29d0 <_balance$0+0xf90>
    20bd:	48 8d 05 90 29 00 00 	lea    rax,[rip+0x2990]        # 4a54 <_IO_stdin_used+0xa54>
    20c4:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    20c8:	48 01 c1             	add    rcx,rax
    20cb:	ff e1                	jmp    rcx
    20cd:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    20d0:	48 83 f9 0a          	cmp    rcx,0xa
    20d4:	0f 87 f6 08 00 00    	ja     29d0 <_balance$0+0xf90>
    20da:	48 8d 05 1b 29 00 00 	lea    rax,[rip+0x291b]        # 49fc <_IO_stdin_used+0x9fc>
    20e1:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    20e5:	48 01 c1             	add    rcx,rax
    20e8:	ff e1                	jmp    rcx
    20ea:	83 fd 0a             	cmp    ebp,0xa
    20ed:	0f 87 df 00 00 00    	ja     21d2 <_balance$0+0x792>
    20f3:	89 e8                	mov    eax,ebp
    20f5:	48 8d 0d c0 2d 00 00 	lea    rcx,[rip+0x2dc0]        # 4ebc <_IO_stdin_used+0xebc>
    20fc:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2100:	48 01 c8             	add    rax,rcx
    2103:	ff e0                	jmp    rax
    2105:	83 fd 0a             	cmp    ebp,0xa
    2108:	0f 87 c4 00 00 00    	ja     21d2 <_balance$0+0x792>
    210e:	89 e8                	mov    eax,ebp
    2110:	48 8d 0d c9 2c 00 00 	lea    rcx,[rip+0x2cc9]        # 4de0 <_IO_stdin_used+0xde0>
    2117:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    211b:	48 01 c8             	add    rax,rcx
    211e:	ff e0                	jmp    rax
    2120:	83 fd 0a             	cmp    ebp,0xa
    2123:	0f 87 a9 00 00 00    	ja     21d2 <_balance$0+0x792>
    2129:	89 e8                	mov    eax,ebp
    212b:	48 8d 0d e2 2d 00 00 	lea    rcx,[rip+0x2de2]        # 4f14 <_IO_stdin_used+0xf14>
    2132:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2136:	48 01 c8             	add    rax,rcx
    2139:	ff e0                	jmp    rax
    213b:	83 fd 0a             	cmp    ebp,0xa
    213e:	0f 87 8e 00 00 00    	ja     21d2 <_balance$0+0x792>
    2144:	89 e8                	mov    eax,ebp
    2146:	48 8d 0d 9b 2d 00 00 	lea    rcx,[rip+0x2d9b]        # 4ee8 <_IO_stdin_used+0xee8>
    214d:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2151:	48 01 c8             	add    rax,rcx
    2154:	ff e0                	jmp    rax
    2156:	83 fd 0a             	cmp    ebp,0xa
    2159:	77 77                	ja     21d2 <_balance$0+0x792>
    215b:	89 e8                	mov    eax,ebp
    215d:	48 8d 0d d4 2c 00 00 	lea    rcx,[rip+0x2cd4]        # 4e38 <_IO_stdin_used+0xe38>
    2164:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2168:	48 01 c8             	add    rax,rcx
    216b:	ff e0                	jmp    rax
    216d:	83 fd 0a             	cmp    ebp,0xa
    2170:	77 60                	ja     21d2 <_balance$0+0x792>
    2172:	89 e8                	mov    eax,ebp
    2174:	48 8d 0d c5 2d 00 00 	lea    rcx,[rip+0x2dc5]        # 4f40 <_IO_stdin_used+0xf40>
    217b:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    217f:	48 01 c8             	add    rax,rcx
    2182:	ff e0                	jmp    rax
    2184:	83 fd 0a             	cmp    ebp,0xa
    2187:	77 49                	ja     21d2 <_balance$0+0x792>
    2189:	89 e8                	mov    eax,ebp
    218b:	48 8d 0d fe 2c 00 00 	lea    rcx,[rip+0x2cfe]        # 4e90 <_IO_stdin_used+0xe90>
    2192:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2196:	48 01 c8             	add    rax,rcx
    2199:	ff e0                	jmp    rax
    219b:	83 fd 0a             	cmp    ebp,0xa
    219e:	77 32                	ja     21d2 <_balance$0+0x792>
    21a0:	89 e8                	mov    eax,ebp
    21a2:	48 8d 0d bb 2c 00 00 	lea    rcx,[rip+0x2cbb]        # 4e64 <_IO_stdin_used+0xe64>
    21a9:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    21ad:	48 01 c8             	add    rax,rcx
    21b0:	ff e0                	jmp    rax
    21b2:	83 fd 0a             	cmp    ebp,0xa
    21b5:	77 1b                	ja     21d2 <_balance$0+0x792>
    21b7:	89 e8                	mov    eax,ebp
    21b9:	48 8d 0d 4c 2c 00 00 	lea    rcx,[rip+0x2c4c]        # 4e0c <_IO_stdin_used+0xe0c>
    21c0:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    21c4:	48 01 c8             	add    rax,rcx
    21c7:	ff e0                	jmp    rax
    21c9:	83 fd 0a             	cmp    ebp,0xa
    21cc:	0f 86 6d 08 00 00    	jbe    2a3f <_balance$0+0xfff>
    21d2:	49 8b 7e 08          	mov    rdi,QWORD PTR [r14+0x8]
    21d6:	48 8d 74 24 10       	lea    rsi,[rsp+0x10]
    21db:	48 89 c2             	mov    rdx,rax
    21de:	31 c0                	xor    eax,eax
    21e0:	ff 17                	call   QWORD PTR [rdi]
    21e2:	49 8b 45 00          	mov    rax,QWORD PTR [r13+0x0]
    21e6:	8b 08                	mov    ecx,DWORD PTR [rax]
    21e8:	83 f9 09             	cmp    ecx,0x9
    21eb:	0f 83 06 08 00 00    	jae    29f7 <_balance$0+0xfb7>
    21f1:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    21f5:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
    21f9:	8b 10                	mov    edx,DWORD PTR [rax]
    21fb:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
    21ff:	49 8b 7e 18          	mov    rdi,QWORD PTR [r14+0x18]
    2203:	48 89 e6             	mov    rsi,rsp
    2206:	31 c0                	xor    eax,eax
    2208:	ff 17                	call   QWORD PTR [rdi]
    220a:	bf 20 00 00 00       	mov    edi,0x20
    220f:	e8 5c ee ff ff       	call   1070 <malloc@plt>
    2214:	8b 4c 24 10          	mov    ecx,DWORD PTR [rsp+0x10]
    2218:	48 83 f9 0a          	cmp    rcx,0xa
    221c:	0f 87 ae 07 00 00    	ja     29d0 <_balance$0+0xf90>
    2222:	48 8d 15 6f 2d 00 00 	lea    rdx,[rip+0x2d6f]        # 4f98 <_IO_stdin_used+0xf98>
    2229:	48 63 0c 8a          	movsxd rcx,DWORD PTR [rdx+rcx*4]
    222d:	48 01 d1             	add    rcx,rdx
    2230:	ff e1                	jmp    rcx
    2232:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2235:	48 83 f9 0a          	cmp    rcx,0xa
    2239:	0f 87 91 07 00 00    	ja     29d0 <_balance$0+0xf90>
    223f:	48 8d 05 36 2f 00 00 	lea    rax,[rip+0x2f36]        # 517c <_IO_stdin_used+0x117c>
    2246:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    224a:	48 01 c1             	add    rcx,rax
    224d:	ff e1                	jmp    rcx
    224f:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2252:	48 83 f9 0a          	cmp    rcx,0xa
    2256:	0f 87 74 07 00 00    	ja     29d0 <_balance$0+0xf90>
    225c:	48 8d 05 69 2e 00 00 	lea    rax,[rip+0x2e69]        # 50cc <_IO_stdin_used+0x10cc>
    2263:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2267:	48 01 c1             	add    rcx,rax
    226a:	ff e1                	jmp    rcx
    226c:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    226f:	48 83 f9 0a          	cmp    rcx,0xa
    2273:	0f 87 57 07 00 00    	ja     29d0 <_balance$0+0xf90>
    2279:	48 8d 05 70 2d 00 00 	lea    rax,[rip+0x2d70]        # 4ff0 <_IO_stdin_used+0xff0>
    2280:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2284:	48 01 c1             	add    rcx,rax
    2287:	ff e1                	jmp    rcx
    2289:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    228c:	48 83 f9 0a          	cmp    rcx,0xa
    2290:	0f 87 3a 07 00 00    	ja     29d0 <_balance$0+0xf90>
    2296:	48 8d 05 87 2e 00 00 	lea    rax,[rip+0x2e87]        # 5124 <_IO_stdin_used+0x1124>
    229d:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    22a1:	48 01 c1             	add    rcx,rax
    22a4:	ff e1                	jmp    rcx
    22a6:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    22a9:	48 83 f9 0a          	cmp    rcx,0xa
    22ad:	0f 87 1d 07 00 00    	ja     29d0 <_balance$0+0xf90>
    22b3:	48 8d 05 96 2e 00 00 	lea    rax,[rip+0x2e96]        # 5150 <_IO_stdin_used+0x1150>
    22ba:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    22be:	48 01 c1             	add    rcx,rax
    22c1:	ff e1                	jmp    rcx
    22c3:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    22c6:	48 83 f9 0a          	cmp    rcx,0xa
    22ca:	0f 87 00 07 00 00    	ja     29d0 <_balance$0+0xf90>
    22d0:	48 8d 05 21 2e 00 00 	lea    rax,[rip+0x2e21]        # 50f8 <_IO_stdin_used+0x10f8>
    22d7:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    22db:	48 01 c1             	add    rcx,rax
    22de:	ff e1                	jmp    rcx
    22e0:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    22e3:	48 83 f9 0a          	cmp    rcx,0xa
    22e7:	0f 87 e3 06 00 00    	ja     29d0 <_balance$0+0xf90>
    22ed:	48 8d 05 54 2d 00 00 	lea    rax,[rip+0x2d54]        # 5048 <_IO_stdin_used+0x1048>
    22f4:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    22f8:	48 01 c1             	add    rcx,rax
    22fb:	ff e1                	jmp    rcx
    22fd:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2300:	48 83 f9 0a          	cmp    rcx,0xa
    2304:	0f 87 c6 06 00 00    	ja     29d0 <_balance$0+0xf90>
    230a:	48 8d 05 8f 2d 00 00 	lea    rax,[rip+0x2d8f]        # 50a0 <_IO_stdin_used+0x10a0>
    2311:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2315:	48 01 c1             	add    rcx,rax
    2318:	ff e1                	jmp    rcx
    231a:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    231d:	48 83 f9 0a          	cmp    rcx,0xa
    2321:	0f 87 a9 06 00 00    	ja     29d0 <_balance$0+0xf90>
    2327:	48 8d 05 46 2d 00 00 	lea    rax,[rip+0x2d46]        # 5074 <_IO_stdin_used+0x1074>
    232e:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2332:	48 01 c1             	add    rcx,rax
    2335:	ff e1                	jmp    rcx
    2337:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    233a:	48 83 f9 0a          	cmp    rcx,0xa
    233e:	0f 87 8c 06 00 00    	ja     29d0 <_balance$0+0xf90>
    2344:	48 8d 05 d1 2c 00 00 	lea    rax,[rip+0x2cd1]        # 501c <_IO_stdin_used+0x101c>
    234b:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    234f:	48 01 c1             	add    rcx,rax
    2352:	ff e1                	jmp    rcx
    2354:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2357:	48 83 f9 0a          	cmp    rcx,0xa
    235b:	0f 87 6f 06 00 00    	ja     29d0 <_balance$0+0xf90>
    2361:	48 8d 05 5c 2c 00 00 	lea    rax,[rip+0x2c5c]        # 4fc4 <_IO_stdin_used+0xfc4>
    2368:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    236c:	48 01 c1             	add    rcx,rax
    236f:	ff e1                	jmp    rcx
    2371:	83 fd 0a             	cmp    ebp,0xa
    2374:	0f 87 df 00 00 00    	ja     2459 <_balance$0+0xa19>
    237a:	89 e8                	mov    eax,ebp
    237c:	48 8d 0d 59 2f 00 00 	lea    rcx,[rip+0x2f59]        # 52dc <_IO_stdin_used+0x12dc>
    2383:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2387:	48 01 c8             	add    rax,rcx
    238a:	ff e0                	jmp    rax
    238c:	83 fd 0a             	cmp    ebp,0xa
    238f:	0f 87 c4 00 00 00    	ja     2459 <_balance$0+0xa19>
    2395:	89 e8                	mov    eax,ebp
    2397:	48 8d 0d 62 2e 00 00 	lea    rcx,[rip+0x2e62]        # 5200 <_IO_stdin_used+0x1200>
    239e:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    23a2:	48 01 c8             	add    rax,rcx
    23a5:	ff e0                	jmp    rax
    23a7:	83 fd 0a             	cmp    ebp,0xa
    23aa:	0f 87 a9 00 00 00    	ja     2459 <_balance$0+0xa19>
    23b0:	89 e8                	mov    eax,ebp
    23b2:	48 8d 0d 7b 2f 00 00 	lea    rcx,[rip+0x2f7b]        # 5334 <_IO_stdin_used+0x1334>
    23b9:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    23bd:	48 01 c8             	add    rax,rcx
    23c0:	ff e0                	jmp    rax
    23c2:	83 fd 0a             	cmp    ebp,0xa
    23c5:	0f 87 8e 00 00 00    	ja     2459 <_balance$0+0xa19>
    23cb:	89 e8                	mov    eax,ebp
    23cd:	48 8d 0d 8c 2f 00 00 	lea    rcx,[rip+0x2f8c]        # 5360 <_IO_stdin_used+0x1360>
    23d4:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    23d8:	48 01 c8             	add    rax,rcx
    23db:	ff e0                	jmp    rax
    23dd:	83 fd 0a             	cmp    ebp,0xa
    23e0:	77 77                	ja     2459 <_balance$0+0xa19>
    23e2:	89 e8                	mov    eax,ebp
    23e4:	48 8d 0d 1d 2f 00 00 	lea    rcx,[rip+0x2f1d]        # 5308 <_IO_stdin_used+0x1308>
    23eb:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    23ef:	48 01 c8             	add    rax,rcx
    23f2:	ff e0                	jmp    rax
    23f4:	83 fd 0a             	cmp    ebp,0xa
    23f7:	77 60                	ja     2459 <_balance$0+0xa19>
    23f9:	89 e8                	mov    eax,ebp
    23fb:	48 8d 0d 56 2e 00 00 	lea    rcx,[rip+0x2e56]        # 5258 <_IO_stdin_used+0x1258>
    2402:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2406:	48 01 c8             	add    rax,rcx
    2409:	ff e0                	jmp    rax
    240b:	83 fd 0a             	cmp    ebp,0xa
    240e:	77 49                	ja     2459 <_balance$0+0xa19>
    2410:	89 e8                	mov    eax,ebp
    2412:	48 8d 0d 97 2e 00 00 	lea    rcx,[rip+0x2e97]        # 52b0 <_IO_stdin_used+0x12b0>
    2419:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    241d:	48 01 c8             	add    rax,rcx
    2420:	ff e0                	jmp    rax
    2422:	83 fd 0a             	cmp    ebp,0xa
    2425:	77 32                	ja     2459 <_balance$0+0xa19>
    2427:	89 e8                	mov    eax,ebp
    2429:	48 8d 0d 54 2e 00 00 	lea    rcx,[rip+0x2e54]        # 5284 <_IO_stdin_used+0x1284>
    2430:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2434:	48 01 c8             	add    rax,rcx
    2437:	ff e0                	jmp    rax
    2439:	83 fd 0a             	cmp    ebp,0xa
    243c:	77 1b                	ja     2459 <_balance$0+0xa19>
    243e:	89 e8                	mov    eax,ebp
    2440:	48 8d 0d e5 2d 00 00 	lea    rcx,[rip+0x2de5]        # 522c <_IO_stdin_used+0x122c>
    2447:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    244b:	48 01 c8             	add    rax,rcx
    244e:	ff e0                	jmp    rax
    2450:	83 fd 0a             	cmp    ebp,0xa
    2453:	0f 86 f8 05 00 00    	jbe    2a51 <_balance$0+0x1011>
    2459:	49 8b 7e 08          	mov    rdi,QWORD PTR [r14+0x8]
    245d:	48 8d 74 24 10       	lea    rsi,[rsp+0x10]
    2462:	48 89 c2             	mov    rdx,rax
    2465:	31 c0                	xor    eax,eax
    2467:	ff 17                	call   QWORD PTR [rdi]
    2469:	49 8b 45 10          	mov    rax,QWORD PTR [r13+0x10]
    246d:	8b 08                	mov    ecx,DWORD PTR [rax]
    246f:	83 f9 09             	cmp    ecx,0x9
    2472:	0f 83 7f 05 00 00    	jae    29f7 <_balance$0+0xfb7>
    2478:	41 8b 4d 00          	mov    ecx,DWORD PTR [r13+0x0]
    247c:	49 83 c5 10          	add    r13,0x10
    2480:	48 8d 15 31 2f 00 00 	lea    rdx,[rip+0x2f31]        # 53b8 <_IO_stdin_used+0x13b8>
    2487:	48 63 0c 8a          	movsxd rcx,DWORD PTR [rdx+rcx*4]
    248b:	48 01 d1             	add    rcx,rdx
    248e:	ff e1                	jmp    rcx
    2490:	48 89 c1             	mov    rcx,rax
    2493:	48 83 c1 08          	add    rcx,0x8
    2497:	8b 00                	mov    eax,DWORD PTR [rax]
    2499:	83 f8 09             	cmp    eax,0x9
    249c:	0f 83 87 00 00 00    	jae    2529 <_balance$0+0xae9>
    24a2:	48 8b 01             	mov    rax,QWORD PTR [rcx]
    24a5:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    24a9:	8b 08                	mov    ecx,DWORD PTR [rax]
    24ab:	83 f9 09             	cmp    ecx,0x9
    24ae:	0f 83 43 05 00 00    	jae    29f7 <_balance$0+0xfb7>
    24b4:	49 8b 4d 00          	mov    rcx,QWORD PTR [r13+0x0]
    24b8:	8b 11                	mov    edx,DWORD PTR [rcx]
    24ba:	83 fa 09             	cmp    edx,0x9
    24bd:	0f 83 3e 05 00 00    	jae    2a01 <_balance$0+0xfc1>
    24c3:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    24c7:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
    24cb:	8b 28                	mov    ebp,DWORD PTR [rax]
    24cd:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
    24d1:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
    24d5:	8b 18                	mov    ebx,DWORD PTR [rax]
    24d7:	bf 20 00 00 00       	mov    edi,0x20
    24dc:	e8 8f eb ff ff       	call   1070 <malloc@plt>
    24e1:	48 83 fd 0a          	cmp    rbp,0xa
    24e5:	0f 87 33 01 00 00    	ja     261e <_balance$0+0xbde>
    24eb:	48 8d 0d aa 30 00 00 	lea    rcx,[rip+0x30aa]        # 559c <_IO_stdin_used+0x159c>
    24f2:	48 63 14 a9          	movsxd rdx,DWORD PTR [rcx+rbp*4]
    24f6:	48 01 ca             	add    rdx,rcx
    24f9:	ff e2                	jmp    rdx
    24fb:	83 fb 0a             	cmp    ebx,0xa
    24fe:	0f 87 1a 01 00 00    	ja     261e <_balance$0+0xbde>
    2504:	89 d8                	mov    eax,ebx
    2506:	48 8d 0d 73 32 00 00 	lea    rcx,[rip+0x3273]        # 5780 <_IO_stdin_used+0x1780>
    250d:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2511:	48 01 c8             	add    rax,rcx
    2514:	ff e0                	jmp    rax
    2516:	49 8b 45 00          	mov    rax,QWORD PTR [r13+0x0]
    251a:	48 8d 48 08          	lea    rcx,[rax+0x8]
    251e:	8b 00                	mov    eax,DWORD PTR [rax]
    2520:	83 f8 09             	cmp    eax,0x9
    2523:	0f 82 79 ff ff ff    	jb     24a2 <_balance$0+0xa62>
    2529:	bf 01 00 00 00       	mov    edi,0x1
    252e:	83 f8 0a             	cmp    eax,0xa
    2531:	e9 d3 04 00 00       	jmp    2a09 <_balance$0+0xfc9>
    2536:	83 fb 0a             	cmp    ebx,0xa
    2539:	0f 87 df 00 00 00    	ja     261e <_balance$0+0xbde>
    253f:	89 d8                	mov    eax,ebx
    2541:	48 8d 0d 88 31 00 00 	lea    rcx,[rip+0x3188]        # 56d0 <_IO_stdin_used+0x16d0>
    2548:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    254c:	48 01 c8             	add    rax,rcx
    254f:	ff e0                	jmp    rax
    2551:	83 fb 0a             	cmp    ebx,0xa
    2554:	0f 87 c4 00 00 00    	ja     261e <_balance$0+0xbde>
    255a:	89 d8                	mov    eax,ebx
    255c:	48 8d 0d 91 30 00 00 	lea    rcx,[rip+0x3091]        # 55f4 <_IO_stdin_used+0x15f4>
    2563:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2567:	48 01 c8             	add    rax,rcx
    256a:	ff e0                	jmp    rax
    256c:	83 fb 0a             	cmp    ebx,0xa
    256f:	0f 87 a9 00 00 00    	ja     261e <_balance$0+0xbde>
    2575:	89 d8                	mov    eax,ebx
    2577:	48 8d 0d aa 31 00 00 	lea    rcx,[rip+0x31aa]        # 5728 <_IO_stdin_used+0x1728>
    257e:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2582:	48 01 c8             	add    rax,rcx
    2585:	ff e0                	jmp    rax
    2587:	83 fb 0a             	cmp    ebx,0xa
    258a:	0f 87 8e 00 00 00    	ja     261e <_balance$0+0xbde>
    2590:	89 d8                	mov    eax,ebx
    2592:	48 8d 0d bb 31 00 00 	lea    rcx,[rip+0x31bb]        # 5754 <_IO_stdin_used+0x1754>
    2599:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    259d:	48 01 c8             	add    rax,rcx
    25a0:	ff e0                	jmp    rax
    25a2:	83 fb 0a             	cmp    ebx,0xa
    25a5:	77 77                	ja     261e <_balance$0+0xbde>
    25a7:	89 d8                	mov    eax,ebx
    25a9:	48 8d 0d 4c 31 00 00 	lea    rcx,[rip+0x314c]        # 56fc <_IO_stdin_used+0x16fc>
    25b0:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    25b4:	48 01 c8             	add    rax,rcx
    25b7:	ff e0                	jmp    rax
    25b9:	83 fb 0a             	cmp    ebx,0xa
    25bc:	77 60                	ja     261e <_balance$0+0xbde>
    25be:	89 d8                	mov    eax,ebx
    25c0:	48 8d 0d 85 30 00 00 	lea    rcx,[rip+0x3085]        # 564c <_IO_stdin_used+0x164c>
    25c7:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    25cb:	48 01 c8             	add    rax,rcx
    25ce:	ff e0                	jmp    rax
    25d0:	83 fb 0a             	cmp    ebx,0xa
    25d3:	77 49                	ja     261e <_balance$0+0xbde>
    25d5:	89 d8                	mov    eax,ebx
    25d7:	48 8d 0d c6 30 00 00 	lea    rcx,[rip+0x30c6]        # 56a4 <_IO_stdin_used+0x16a4>
    25de:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    25e2:	48 01 c8             	add    rax,rcx
    25e5:	ff e0                	jmp    rax
    25e7:	83 fb 0a             	cmp    ebx,0xa
    25ea:	77 32                	ja     261e <_balance$0+0xbde>
    25ec:	89 d8                	mov    eax,ebx
    25ee:	48 8d 0d 83 30 00 00 	lea    rcx,[rip+0x3083]        # 5678 <_IO_stdin_used+0x1678>
    25f5:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    25f9:	48 01 c8             	add    rax,rcx
    25fc:	ff e0                	jmp    rax
    25fe:	83 fb 0a             	cmp    ebx,0xa
    2601:	77 1b                	ja     261e <_balance$0+0xbde>
    2603:	89 d8                	mov    eax,ebx
    2605:	48 8d 0d 14 30 00 00 	lea    rcx,[rip+0x3014]        # 5620 <_IO_stdin_used+0x1620>
    260c:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2610:	48 01 c8             	add    rax,rcx
    2613:	ff e0                	jmp    rax
    2615:	83 fb 0a             	cmp    ebx,0xa
    2618:	0f 86 45 04 00 00    	jbe    2a63 <_balance$0+0x1023>
    261e:	49 8b 7e 08          	mov    rdi,QWORD PTR [r14+0x8]
    2622:	48 89 e6             	mov    rsi,rsp
    2625:	48 89 c2             	mov    rdx,rax
    2628:	31 c0                	xor    eax,eax
    262a:	ff 17                	call   QWORD PTR [rdi]
    262c:	bf 20 00 00 00       	mov    edi,0x20
    2631:	e8 3a ea ff ff       	call   1070 <malloc@plt>
    2636:	8b 4c 24 10          	mov    ecx,DWORD PTR [rsp+0x10]
    263a:	48 83 f9 0a          	cmp    rcx,0xa
    263e:	0f 87 8c 03 00 00    	ja     29d0 <_balance$0+0xf90>
    2644:	48 8d 15 61 31 00 00 	lea    rdx,[rip+0x3161]        # 57ac <_IO_stdin_used+0x17ac>
    264b:	48 63 0c 8a          	movsxd rcx,DWORD PTR [rdx+rcx*4]
    264f:	48 01 d1             	add    rcx,rdx
    2652:	ff e1                	jmp    rcx
    2654:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2657:	48 83 f9 0a          	cmp    rcx,0xa
    265b:	0f 87 6f 03 00 00    	ja     29d0 <_balance$0+0xf90>
    2661:	48 8d 05 28 33 00 00 	lea    rax,[rip+0x3328]        # 5990 <_IO_stdin_used+0x1990>
    2668:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    266c:	48 01 c1             	add    rcx,rax
    266f:	ff e1                	jmp    rcx
    2671:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2674:	48 83 f9 0a          	cmp    rcx,0xa
    2678:	0f 87 52 03 00 00    	ja     29d0 <_balance$0+0xf90>
    267e:	48 8d 05 5b 32 00 00 	lea    rax,[rip+0x325b]        # 58e0 <_IO_stdin_used+0x18e0>
    2685:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2689:	48 01 c1             	add    rcx,rax
    268c:	ff e1                	jmp    rcx
    268e:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2691:	48 83 f9 0a          	cmp    rcx,0xa
    2695:	0f 87 35 03 00 00    	ja     29d0 <_balance$0+0xf90>
    269b:	48 8d 05 62 31 00 00 	lea    rax,[rip+0x3162]        # 5804 <_IO_stdin_used+0x1804>
    26a2:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    26a6:	48 01 c1             	add    rcx,rax
    26a9:	ff e1                	jmp    rcx
    26ab:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    26ae:	48 83 f9 0a          	cmp    rcx,0xa
    26b2:	0f 87 18 03 00 00    	ja     29d0 <_balance$0+0xf90>
    26b8:	48 8d 05 79 32 00 00 	lea    rax,[rip+0x3279]        # 5938 <_IO_stdin_used+0x1938>
    26bf:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    26c3:	48 01 c1             	add    rcx,rax
    26c6:	ff e1                	jmp    rcx
    26c8:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    26cb:	48 83 f9 0a          	cmp    rcx,0xa
    26cf:	0f 87 fb 02 00 00    	ja     29d0 <_balance$0+0xf90>
    26d5:	48 8d 05 88 32 00 00 	lea    rax,[rip+0x3288]        # 5964 <_IO_stdin_used+0x1964>
    26dc:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    26e0:	48 01 c1             	add    rcx,rax
    26e3:	ff e1                	jmp    rcx
    26e5:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    26e8:	48 83 f9 0a          	cmp    rcx,0xa
    26ec:	0f 87 de 02 00 00    	ja     29d0 <_balance$0+0xf90>
    26f2:	48 8d 05 13 32 00 00 	lea    rax,[rip+0x3213]        # 590c <_IO_stdin_used+0x190c>
    26f9:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    26fd:	48 01 c1             	add    rcx,rax
    2700:	ff e1                	jmp    rcx
    2702:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2705:	48 83 f9 0a          	cmp    rcx,0xa
    2709:	0f 87 c1 02 00 00    	ja     29d0 <_balance$0+0xf90>
    270f:	48 8d 05 46 31 00 00 	lea    rax,[rip+0x3146]        # 585c <_IO_stdin_used+0x185c>
    2716:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    271a:	48 01 c1             	add    rcx,rax
    271d:	ff e1                	jmp    rcx
    271f:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2722:	48 83 f9 0a          	cmp    rcx,0xa
    2726:	0f 87 a4 02 00 00    	ja     29d0 <_balance$0+0xf90>
    272c:	48 8d 05 81 31 00 00 	lea    rax,[rip+0x3181]        # 58b4 <_IO_stdin_used+0x18b4>
    2733:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2737:	48 01 c1             	add    rcx,rax
    273a:	ff e1                	jmp    rcx
    273c:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    273f:	48 83 f9 0a          	cmp    rcx,0xa
    2743:	0f 87 87 02 00 00    	ja     29d0 <_balance$0+0xf90>
    2749:	48 8d 05 38 31 00 00 	lea    rax,[rip+0x3138]        # 5888 <_IO_stdin_used+0x1888>
    2750:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2754:	48 01 c1             	add    rcx,rax
    2757:	ff e1                	jmp    rcx
    2759:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    275c:	48 83 f9 0a          	cmp    rcx,0xa
    2760:	0f 87 6a 02 00 00    	ja     29d0 <_balance$0+0xf90>
    2766:	48 8d 05 c3 30 00 00 	lea    rax,[rip+0x30c3]        # 5830 <_IO_stdin_used+0x1830>
    276d:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2771:	48 01 c1             	add    rcx,rax
    2774:	ff e1                	jmp    rcx
    2776:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2779:	48 83 f9 0a          	cmp    rcx,0xa
    277d:	0f 87 4d 02 00 00    	ja     29d0 <_balance$0+0xf90>
    2783:	48 8d 05 4e 30 00 00 	lea    rax,[rip+0x304e]        # 57d8 <_IO_stdin_used+0x17d8>
    278a:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    278e:	48 01 c1             	add    rcx,rax
    2791:	ff e1                	jmp    rcx
    2793:	83 fb 0a             	cmp    ebx,0xa
    2796:	0f 87 df 00 00 00    	ja     287b <_balance$0+0xe3b>
    279c:	89 d8                	mov    eax,ebx
    279e:	48 8d 0d 4b 33 00 00 	lea    rcx,[rip+0x334b]        # 5af0 <_IO_stdin_used+0x1af0>
    27a5:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    27a9:	48 01 c8             	add    rax,rcx
    27ac:	ff e0                	jmp    rax
    27ae:	83 fb 0a             	cmp    ebx,0xa
    27b1:	0f 87 c4 00 00 00    	ja     287b <_balance$0+0xe3b>
    27b7:	89 d8                	mov    eax,ebx
    27b9:	48 8d 0d 88 33 00 00 	lea    rcx,[rip+0x3388]        # 5b48 <_IO_stdin_used+0x1b48>
    27c0:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    27c4:	48 01 c8             	add    rax,rcx
    27c7:	ff e0                	jmp    rax
    27c9:	83 fb 0a             	cmp    ebx,0xa
    27cc:	0f 87 a9 00 00 00    	ja     287b <_balance$0+0xe3b>
    27d2:	89 d8                	mov    eax,ebx
    27d4:	48 8d 0d 39 32 00 00 	lea    rcx,[rip+0x3239]        # 5a14 <_IO_stdin_used+0x1a14>
    27db:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    27df:	48 01 c8             	add    rax,rcx
    27e2:	ff e0                	jmp    rax
    27e4:	83 fb 0a             	cmp    ebx,0xa
    27e7:	0f 87 8e 00 00 00    	ja     287b <_balance$0+0xe3b>
    27ed:	89 d8                	mov    eax,ebx
    27ef:	48 8d 0d 7e 33 00 00 	lea    rcx,[rip+0x337e]        # 5b74 <_IO_stdin_used+0x1b74>
    27f6:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    27fa:	48 01 c8             	add    rax,rcx
    27fd:	ff e0                	jmp    rax
    27ff:	83 fb 0a             	cmp    ebx,0xa
    2802:	77 77                	ja     287b <_balance$0+0xe3b>
    2804:	89 d8                	mov    eax,ebx
    2806:	48 8d 0d 0f 33 00 00 	lea    rcx,[rip+0x330f]        # 5b1c <_IO_stdin_used+0x1b1c>
    280d:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2811:	48 01 c8             	add    rax,rcx
    2814:	ff e0                	jmp    rax
    2816:	83 fb 0a             	cmp    ebx,0xa
    2819:	77 60                	ja     287b <_balance$0+0xe3b>
    281b:	89 d8                	mov    eax,ebx
    281d:	48 8d 0d 48 32 00 00 	lea    rcx,[rip+0x3248]        # 5a6c <_IO_stdin_used+0x1a6c>
    2824:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2828:	48 01 c8             	add    rax,rcx
    282b:	ff e0                	jmp    rax
    282d:	83 fb 0a             	cmp    ebx,0xa
    2830:	77 49                	ja     287b <_balance$0+0xe3b>
    2832:	89 d8                	mov    eax,ebx
    2834:	48 8d 0d 89 32 00 00 	lea    rcx,[rip+0x3289]        # 5ac4 <_IO_stdin_used+0x1ac4>
    283b:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    283f:	48 01 c8             	add    rax,rcx
    2842:	ff e0                	jmp    rax
    2844:	83 fb 0a             	cmp    ebx,0xa
    2847:	77 32                	ja     287b <_balance$0+0xe3b>
    2849:	89 d8                	mov    eax,ebx
    284b:	48 8d 0d 46 32 00 00 	lea    rcx,[rip+0x3246]        # 5a98 <_IO_stdin_used+0x1a98>
    2852:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2856:	48 01 c8             	add    rax,rcx
    2859:	ff e0                	jmp    rax
    285b:	83 fb 0a             	cmp    ebx,0xa
    285e:	77 1b                	ja     287b <_balance$0+0xe3b>
    2860:	89 d8                	mov    eax,ebx
    2862:	48 8d 0d d7 31 00 00 	lea    rcx,[rip+0x31d7]        # 5a40 <_IO_stdin_used+0x1a40>
    2869:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    286d:	48 01 c8             	add    rax,rcx
    2870:	ff e0                	jmp    rax
    2872:	83 fb 0a             	cmp    ebx,0xa
    2875:	0f 86 fa 01 00 00    	jbe    2a75 <_balance$0+0x1035>
    287b:	49 8b 7e 08          	mov    rdi,QWORD PTR [r14+0x8]
    287f:	48 89 e6             	mov    rsi,rsp
    2882:	48 89 c2             	mov    rdx,rax
    2885:	31 c0                	xor    eax,eax
    2887:	ff 17                	call   QWORD PTR [rdi]
    2889:	bf 20 00 00 00       	mov    edi,0x20
    288e:	e8 dd e7 ff ff       	call   1070 <malloc@plt>
    2893:	8b 4c 24 10          	mov    ecx,DWORD PTR [rsp+0x10]
    2897:	48 83 f9 0a          	cmp    rcx,0xa
    289b:	0f 87 2f 01 00 00    	ja     29d0 <_balance$0+0xf90>
    28a1:	48 8d 15 24 33 00 00 	lea    rdx,[rip+0x3324]        # 5bcc <_IO_stdin_used+0x1bcc>
    28a8:	48 63 0c 8a          	movsxd rcx,DWORD PTR [rdx+rcx*4]
    28ac:	48 01 d1             	add    rcx,rdx
    28af:	ff e1                	jmp    rcx
    28b1:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    28b4:	48 83 f9 0a          	cmp    rcx,0xa
    28b8:	0f 87 12 01 00 00    	ja     29d0 <_balance$0+0xf90>
    28be:	48 8d 05 eb 34 00 00 	lea    rax,[rip+0x34eb]        # 5db0 <_IO_stdin_used+0x1db0>
    28c5:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    28c9:	48 01 c1             	add    rcx,rax
    28cc:	ff e1                	jmp    rcx
    28ce:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    28d1:	48 83 f9 0a          	cmp    rcx,0xa
    28d5:	0f 87 f5 00 00 00    	ja     29d0 <_balance$0+0xf90>
    28db:	48 8d 05 1e 34 00 00 	lea    rax,[rip+0x341e]        # 5d00 <_IO_stdin_used+0x1d00>
    28e2:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    28e6:	48 01 c1             	add    rcx,rax
    28e9:	ff e1                	jmp    rcx
    28eb:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    28ee:	48 83 f9 0a          	cmp    rcx,0xa
    28f2:	0f 87 d8 00 00 00    	ja     29d0 <_balance$0+0xf90>
    28f8:	48 8d 05 59 34 00 00 	lea    rax,[rip+0x3459]        # 5d58 <_IO_stdin_used+0x1d58>
    28ff:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2903:	48 01 c1             	add    rcx,rax
    2906:	ff e1                	jmp    rcx
    2908:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    290b:	48 83 f9 0a          	cmp    rcx,0xa
    290f:	0f 87 bb 00 00 00    	ja     29d0 <_balance$0+0xf90>
    2915:	48 8d 05 08 33 00 00 	lea    rax,[rip+0x3308]        # 5c24 <_IO_stdin_used+0x1c24>
    291c:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2920:	48 01 c1             	add    rcx,rax
    2923:	ff e1                	jmp    rcx
    2925:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2928:	48 83 f9 0a          	cmp    rcx,0xa
    292c:	0f 87 9e 00 00 00    	ja     29d0 <_balance$0+0xf90>
    2932:	48 8d 05 4b 34 00 00 	lea    rax,[rip+0x344b]        # 5d84 <_IO_stdin_used+0x1d84>
    2939:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    293d:	48 01 c1             	add    rcx,rax
    2940:	ff e1                	jmp    rcx
    2942:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2945:	48 83 f9 0a          	cmp    rcx,0xa
    2949:	0f 87 81 00 00 00    	ja     29d0 <_balance$0+0xf90>
    294f:	48 8d 05 d6 33 00 00 	lea    rax,[rip+0x33d6]        # 5d2c <_IO_stdin_used+0x1d2c>
    2956:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    295a:	48 01 c1             	add    rcx,rax
    295d:	ff e1                	jmp    rcx
    295f:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2962:	48 83 f9 0a          	cmp    rcx,0xa
    2966:	77 68                	ja     29d0 <_balance$0+0xf90>
    2968:	48 8d 05 0d 33 00 00 	lea    rax,[rip+0x330d]        # 5c7c <_IO_stdin_used+0x1c7c>
    296f:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2973:	48 01 c1             	add    rcx,rax
    2976:	ff e1                	jmp    rcx
    2978:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    297b:	48 83 f9 0a          	cmp    rcx,0xa
    297f:	77 4f                	ja     29d0 <_balance$0+0xf90>
    2981:	48 8d 05 4c 33 00 00 	lea    rax,[rip+0x334c]        # 5cd4 <_IO_stdin_used+0x1cd4>
    2988:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    298c:	48 01 c1             	add    rcx,rax
    298f:	ff e1                	jmp    rcx
    2991:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    2994:	48 83 f9 0a          	cmp    rcx,0xa
    2998:	77 36                	ja     29d0 <_balance$0+0xf90>
    299a:	48 8d 05 07 33 00 00 	lea    rax,[rip+0x3307]        # 5ca8 <_IO_stdin_used+0x1ca8>
    29a1:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    29a5:	48 01 c1             	add    rcx,rax
    29a8:	ff e1                	jmp    rcx
    29aa:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    29ad:	48 83 f9 0a          	cmp    rcx,0xa
    29b1:	77 1d                	ja     29d0 <_balance$0+0xf90>
    29b3:	48 8d 05 96 32 00 00 	lea    rax,[rip+0x3296]        # 5c50 <_IO_stdin_used+0x1c50>
    29ba:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    29be:	48 01 c1             	add    rcx,rax
    29c1:	ff e1                	jmp    rcx
    29c3:	8b 0c 24             	mov    ecx,DWORD PTR [rsp]
    29c6:	48 83 f9 0a          	cmp    rcx,0xa
    29ca:	0f 86 b7 00 00 00    	jbe    2a87 <_balance$0+0x1047>
    29d0:	49 8b 7e 10          	mov    rdi,QWORD PTR [r14+0x10]
    29d4:	4c 89 fe             	mov    rsi,r15
    29d7:	48 89 c2             	mov    rdx,rax
    29da:	31 c0                	xor    eax,eax
    29dc:	ff 17                	call   QWORD PTR [rdi]
    29de:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    29e5:	00 00 
    29e7:	48 3b 44 24 20       	cmp    rax,QWORD PTR [rsp+0x20]
    29ec:	0f 84 c7 f0 ff ff    	je     1ab9 <_balance$0+0x79>
    29f2:	e8 39 e6 ff ff       	call   1030 <__stack_chk_fail@plt>
    29f7:	bf 01 00 00 00       	mov    edi,0x1
    29fc:	83 f9 0a             	cmp    ecx,0xa
    29ff:	eb 08                	jmp    2a09 <_balance$0+0xfc9>
    2a01:	bf 01 00 00 00       	mov    edi,0x1
    2a06:	83 fa 0a             	cmp    edx,0xa
    2a09:	e8 82 e6 ff ff       	call   1090 <exit@plt>
    2a0e:	83 f9 0a             	cmp    ecx,0xa
    2a11:	bf 01 00 00 00       	mov    edi,0x1
    2a16:	e8 75 e6 ff ff       	call   1090 <exit@plt>
    2a1b:	89 e8                	mov    eax,ebp
    2a1d:	48 8d 0d b8 1b 00 00 	lea    rcx,[rip+0x1bb8]        # 45dc <_IO_stdin_used+0x5dc>
    2a24:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2a28:	48 01 c8             	add    rax,rcx
    2a2b:	ff e0                	jmp    rax
    2a2d:	89 d8                	mov    eax,ebx
    2a2f:	48 8d 0d b6 1d 00 00 	lea    rcx,[rip+0x1db6]        # 47ec <_IO_stdin_used+0x7ec>
    2a36:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2a3a:	48 01 c8             	add    rax,rcx
    2a3d:	ff e0                	jmp    rax
    2a3f:	89 e8                	mov    eax,ebp
    2a41:	48 8d 0d 6c 23 00 00 	lea    rcx,[rip+0x236c]        # 4db4 <_IO_stdin_used+0xdb4>
    2a48:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2a4c:	48 01 c8             	add    rax,rcx
    2a4f:	ff e0                	jmp    rax
    2a51:	89 e8                	mov    eax,ebp
    2a53:	48 8d 0d 7a 27 00 00 	lea    rcx,[rip+0x277a]        # 51d4 <_IO_stdin_used+0x11d4>
    2a5a:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2a5e:	48 01 c8             	add    rax,rcx
    2a61:	ff e0                	jmp    rax
    2a63:	89 d8                	mov    eax,ebx
    2a65:	48 8d 0d 5c 2b 00 00 	lea    rcx,[rip+0x2b5c]        # 55c8 <_IO_stdin_used+0x15c8>
    2a6c:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2a70:	48 01 c8             	add    rax,rcx
    2a73:	ff e0                	jmp    rax
    2a75:	89 d8                	mov    eax,ebx
    2a77:	48 8d 0d 6a 2f 00 00 	lea    rcx,[rip+0x2f6a]        # 59e8 <_IO_stdin_used+0x19e8>
    2a7e:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2a82:	48 01 c8             	add    rax,rcx
    2a85:	ff e0                	jmp    rax
    2a87:	48 8d 05 6a 31 00 00 	lea    rax,[rip+0x316a]        # 5bf8 <_IO_stdin_used+0x1bf8>
    2a8e:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2a92:	48 01 c1             	add    rcx,rax
    2a95:	ff e1                	jmp    rcx
    2a97:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
    2a9e:	00 00 

0000000000002aa0 <_$144>:
    2aa0:	41 56                	push   r14
    2aa2:	53                   	push   rbx
    2aa3:	48 83 ec 28          	sub    rsp,0x28
    2aa7:	48 89 d3             	mov    rbx,rdx
    2aaa:	49 89 f6             	mov    r14,rsi
    2aad:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2ab4:	00 00 
    2ab6:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
    2abb:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
    2abf:	48 8b 57 10          	mov    rdx,QWORD PTR [rdi+0x10]
    2ac3:	48 8d 74 24 18       	lea    rsi,[rsp+0x18]
    2ac8:	48 89 cf             	mov    rdi,rcx
    2acb:	31 c0                	xor    eax,eax
    2acd:	ff 11                	call   QWORD PTR [rcx]
    2acf:	48 8b 43 10          	mov    rax,QWORD PTR [rbx+0x10]
    2ad3:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
    2ad7:	8b 10                	mov    edx,DWORD PTR [rax]
    2ad9:	48 8b 7c 24 18       	mov    rdi,QWORD PTR [rsp+0x18]
    2ade:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
    2ae3:	31 c0                	xor    eax,eax
    2ae5:	ff 17                	call   QWORD PTR [rdi]
    2ae7:	bf 20 00 00 00       	mov    edi,0x20
    2aec:	e8 7f e5 ff ff       	call   1070 <malloc@plt>
    2af1:	49 89 06             	mov    QWORD PTR [r14],rax
    2af4:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2afb:	00 00 
    2afd:	48 3b 44 24 20       	cmp    rax,QWORD PTR [rsp+0x20]
    2b02:	75 08                	jne    2b0c <_$144+0x6c>
    2b04:	48 83 c4 28          	add    rsp,0x28
    2b08:	5b                   	pop    rbx
    2b09:	41 5e                	pop    r14
    2b0b:	c3                   	ret    
    2b0c:	e8 1f e5 ff ff       	call   1030 <__stack_chk_fail@plt>
    2b11:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    2b18:	00 00 00 
    2b1b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000002b20 <_$132>:
    2b20:	41 56                	push   r14
    2b22:	53                   	push   rbx
    2b23:	48 83 ec 28          	sub    rsp,0x28
    2b27:	48 89 d3             	mov    rbx,rdx
    2b2a:	49 89 f6             	mov    r14,rsi
    2b2d:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2b34:	00 00 
    2b36:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
    2b3b:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
    2b3f:	48 8b 57 10          	mov    rdx,QWORD PTR [rdi+0x10]
    2b43:	48 8d 74 24 18       	lea    rsi,[rsp+0x18]
    2b48:	48 89 cf             	mov    rdi,rcx
    2b4b:	31 c0                	xor    eax,eax
    2b4d:	ff 11                	call   QWORD PTR [rcx]
    2b4f:	48 8b 43 08          	mov    rax,QWORD PTR [rbx+0x8]
    2b53:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
    2b57:	8b 10                	mov    edx,DWORD PTR [rax]
    2b59:	48 8b 7c 24 18       	mov    rdi,QWORD PTR [rsp+0x18]
    2b5e:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
    2b63:	31 c0                	xor    eax,eax
    2b65:	ff 17                	call   QWORD PTR [rdi]
    2b67:	bf 20 00 00 00       	mov    edi,0x20
    2b6c:	e8 ff e4 ff ff       	call   1070 <malloc@plt>
    2b71:	49 89 06             	mov    QWORD PTR [r14],rax
    2b74:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2b7b:	00 00 
    2b7d:	48 3b 44 24 20       	cmp    rax,QWORD PTR [rsp+0x20]
    2b82:	75 08                	jne    2b8c <_$132+0x6c>
    2b84:	48 83 c4 28          	add    rsp,0x28
    2b88:	5b                   	pop    rbx
    2b89:	41 5e                	pop    r14
    2b8b:	c3                   	ret    
    2b8c:	e8 9f e4 ff ff       	call   1030 <__stack_chk_fail@plt>
    2b91:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    2b98:	00 00 00 
    2b9b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000002ba0 <_$119>:
    2ba0:	55                   	push   rbp
    2ba1:	41 57                	push   r15
    2ba3:	41 56                	push   r14
    2ba5:	53                   	push   rbx
    2ba6:	48 83 ec 28          	sub    rsp,0x28
    2baa:	49 89 f6             	mov    r14,rsi
    2bad:	48 89 fb             	mov    rbx,rdi
    2bb0:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2bb7:	00 00 
    2bb9:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
    2bbe:	83 fa 09             	cmp    edx,0x9
    2bc1:	77 4a                	ja     2c0d <_$119+0x6d>
    2bc3:	49 89 cf             	mov    r15,rcx
    2bc6:	89 d5                	mov    ebp,edx
    2bc8:	48 8b 7b 28          	mov    rdi,QWORD PTR [rbx+0x28]
    2bcc:	48 8d 74 24 18       	lea    rsi,[rsp+0x18]
    2bd1:	31 c0                	xor    eax,eax
    2bd3:	ff 17                	call   QWORD PTR [rdi]
    2bd5:	48 8b 44 24 18       	mov    rax,QWORD PTR [rsp+0x18]
    2bda:	48 39 43 40          	cmp    QWORD PTR [rbx+0x40],rax
    2bde:	7d 54                	jge    2c34 <_$119+0x94>
    2be0:	48 8b 7b 38          	mov    rdi,QWORD PTR [rbx+0x38]
    2be4:	48 8d 74 24 10       	lea    rsi,[rsp+0x10]
    2be9:	89 ea                	mov    edx,ebp
    2beb:	4c 89 f9             	mov    rcx,r15
    2bee:	31 c0                	xor    eax,eax
    2bf0:	ff 17                	call   QWORD PTR [rdi]
    2bf2:	bf 18 00 00 00       	mov    edi,0x18
    2bf7:	e8 74 e4 ff ff       	call   1070 <malloc@plt>
    2bfc:	48 8b 4b 30          	mov    rcx,QWORD PTR [rbx+0x30]
    2c00:	48 8b 53 40          	mov    rdx,QWORD PTR [rbx+0x40]
    2c04:	48 8d 35 15 ff ff ff 	lea    rsi,[rip+0xffffffffffffff15]        # 2b20 <_$132>
    2c0b:	eb 5d                	jmp    2c6a <_$119+0xca>
    2c0d:	bf 20 00 00 00       	mov    edi,0x20
    2c12:	e8 59 e4 ff ff       	call   1070 <malloc@plt>
    2c17:	8b 4b 18             	mov    ecx,DWORD PTR [rbx+0x18]
    2c1a:	48 83 f9 0a          	cmp    rcx,0xa
    2c1e:	0f 86 8e 00 00 00    	jbe    2cb2 <_$119+0x112>
    2c24:	48 8b 7b 08          	mov    rdi,QWORD PTR [rbx+0x8]
    2c28:	4c 89 f6             	mov    rsi,r14
    2c2b:	48 89 c2             	mov    rdx,rax
    2c2e:	31 c0                	xor    eax,eax
    2c30:	ff 17                	call   QWORD PTR [rdi]
    2c32:	eb 63                	jmp    2c97 <_$119+0xf7>
    2c34:	75 09                	jne    2c3f <_$119+0x9f>
    2c36:	41 89 2e             	mov    DWORD PTR [r14],ebp
    2c39:	4d 89 7e 08          	mov    QWORD PTR [r14+0x8],r15
    2c3d:	eb 58                	jmp    2c97 <_$119+0xf7>
    2c3f:	48 8b 7b 38          	mov    rdi,QWORD PTR [rbx+0x38]
    2c43:	48 8d 74 24 10       	lea    rsi,[rsp+0x10]
    2c48:	89 ea                	mov    edx,ebp
    2c4a:	4c 89 f9             	mov    rcx,r15
    2c4d:	31 c0                	xor    eax,eax
    2c4f:	ff 17                	call   QWORD PTR [rdi]
    2c51:	bf 18 00 00 00       	mov    edi,0x18
    2c56:	e8 15 e4 ff ff       	call   1070 <malloc@plt>
    2c5b:	48 8b 4b 30          	mov    rcx,QWORD PTR [rbx+0x30]
    2c5f:	48 8b 53 40          	mov    rdx,QWORD PTR [rbx+0x40]
    2c63:	48 8d 35 36 fe ff ff 	lea    rsi,[rip+0xfffffffffffffe36]        # 2aa0 <_$144>
    2c6a:	48 89 30             	mov    QWORD PTR [rax],rsi
    2c6d:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
    2c71:	48 89 50 10          	mov    QWORD PTR [rax+0x10],rdx
    2c75:	48 8b 7c 24 10       	mov    rdi,QWORD PTR [rsp+0x10]
    2c7a:	48 89 e6             	mov    rsi,rsp
    2c7d:	48 89 c2             	mov    rdx,rax
    2c80:	31 c0                	xor    eax,eax
    2c82:	ff 17                	call   QWORD PTR [rdi]
    2c84:	48 8b 7b 10          	mov    rdi,QWORD PTR [rbx+0x10]
    2c88:	8b 14 24             	mov    edx,DWORD PTR [rsp]
    2c8b:	48 8b 4c 24 08       	mov    rcx,QWORD PTR [rsp+0x8]
    2c90:	4c 89 f6             	mov    rsi,r14
    2c93:	31 c0                	xor    eax,eax
    2c95:	ff 17                	call   QWORD PTR [rdi]
    2c97:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2c9e:	00 00 
    2ca0:	48 3b 44 24 20       	cmp    rax,QWORD PTR [rsp+0x20]
    2ca5:	75 25                	jne    2ccc <_$119+0x12c>
    2ca7:	48 83 c4 28          	add    rsp,0x28
    2cab:	5b                   	pop    rbx
    2cac:	41 5e                	pop    r14
    2cae:	41 5f                	pop    r15
    2cb0:	5d                   	pop    rbp
    2cb1:	c3                   	ret    
    2cb2:	48 8d 05 23 31 00 00 	lea    rax,[rip+0x3123]        # 5ddc <_IO_stdin_used+0x1ddc>
    2cb9:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
    2cbd:	48 01 c1             	add    rcx,rax
    2cc0:	ff e1                	jmp    rcx
    2cc2:	bf 01 00 00 00       	mov    edi,0x1
    2cc7:	e8 c4 e3 ff ff       	call   1090 <exit@plt>
    2ccc:	e8 5f e3 ff ff       	call   1030 <__stack_chk_fail@plt>
    2cd1:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    2cd8:	00 00 00 
    2cdb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000002ce0 <_insert$0>:
    2ce0:	41 57                	push   r15
    2ce2:	41 56                	push   r14
    2ce4:	53                   	push   rbx
    2ce5:	49 89 d7             	mov    r15,rdx
    2ce8:	49 89 f6             	mov    r14,rsi
    2ceb:	48 89 fb             	mov    rbx,rdi
    2cee:	bf 48 00 00 00       	mov    edi,0x48
    2cf3:	e8 78 e3 ff ff       	call   1070 <malloc@plt>
    2cf8:	0f 10 43 08          	movups xmm0,XMMWORD PTR [rbx+0x8]
    2cfc:	48 8b 4b 28          	mov    rcx,QWORD PTR [rbx+0x28]
    2d00:	48 8b 53 30          	mov    rdx,QWORD PTR [rbx+0x30]
    2d04:	48 8d 35 95 fe ff ff 	lea    rsi,[rip+0xfffffffffffffe95]        # 2ba0 <_$119>
    2d0b:	48 89 30             	mov    QWORD PTR [rax],rsi
    2d0e:	0f 11 40 08          	movups XMMWORD PTR [rax+0x8],xmm0
    2d12:	0f 10 43 18          	movups xmm0,XMMWORD PTR [rbx+0x18]
    2d16:	0f 11 40 18          	movups XMMWORD PTR [rax+0x18],xmm0
    2d1a:	48 89 48 28          	mov    QWORD PTR [rax+0x28],rcx
    2d1e:	48 89 58 30          	mov    QWORD PTR [rax+0x30],rbx
    2d22:	48 89 50 38          	mov    QWORD PTR [rax+0x38],rdx
    2d26:	4c 89 78 40          	mov    QWORD PTR [rax+0x40],r15
    2d2a:	49 89 06             	mov    QWORD PTR [r14],rax
    2d2d:	5b                   	pop    rbx
    2d2e:	41 5e                	pop    r14
    2d30:	41 5f                	pop    r15
    2d32:	c3                   	ret    
    2d33:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    2d3a:	00 00 00 
    2d3d:	0f 1f 00             	nop    DWORD PTR [rax]

0000000000002d40 <_count_red$0>:
    2d40:	41 57                	push   r15
    2d42:	41 56                	push   r14
    2d44:	41 54                	push   r12
    2d46:	53                   	push   rbx
    2d47:	48 83 ec 18          	sub    rsp,0x18
    2d4b:	49 89 cc             	mov    r12,rcx
    2d4e:	49 89 f6             	mov    r14,rsi
    2d51:	49 89 ff             	mov    r15,rdi
    2d54:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2d5b:	00 00 
    2d5d:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
    2d62:	83 fa 09             	cmp    edx,0x9
    2d65:	73 5d                	jae    2dc4 <_count_red$0+0x84>
    2d67:	49 8b 44 24 08       	mov    rax,QWORD PTR [r12+0x8]
    2d6c:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
    2d70:	8b 10                	mov    edx,DWORD PTR [rax]
    2d72:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
    2d77:	4c 89 ff             	mov    rdi,r15
    2d7a:	e8 c1 ff ff ff       	call   2d40 <_count_red$0>
    2d7f:	48 8b 5c 24 08       	mov    rbx,QWORD PTR [rsp+0x8]
    2d84:	49 8b 44 24 10       	mov    rax,QWORD PTR [r12+0x10]
    2d89:	8b 10                	mov    edx,DWORD PTR [rax]
    2d8b:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
    2d8f:	48 89 e6             	mov    rsi,rsp
    2d92:	4c 89 ff             	mov    rdi,r15
    2d95:	e8 a6 ff ff ff       	call   2d40 <_count_red$0>
    2d9a:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
    2d9e:	48 01 d8             	add    rax,rbx
    2da1:	48 83 c0 01          	add    rax,0x1
    2da5:	49 89 06             	mov    QWORD PTR [r14],rax
    2da8:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2daf:	00 00 
    2db1:	48 3b 44 24 10       	cmp    rax,QWORD PTR [rsp+0x10]
    2db6:	75 25                	jne    2ddd <_count_red$0+0x9d>
    2db8:	48 83 c4 18          	add    rsp,0x18
    2dbc:	5b                   	pop    rbx
    2dbd:	41 5c                	pop    r12
    2dbf:	41 5e                	pop    r14
    2dc1:	41 5f                	pop    r15
    2dc3:	c3                   	ret    
    2dc4:	74 1c                	je     2de2 <_count_red$0+0xa2>
    2dc6:	49 c7 06 00 00 00 00 	mov    QWORD PTR [r14],0x0
    2dcd:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2dd4:	00 00 
    2dd6:	48 3b 44 24 10       	cmp    rax,QWORD PTR [rsp+0x10]
    2ddb:	74 db                	je     2db8 <_count_red$0+0x78>
    2ddd:	e8 4e e2 ff ff       	call   1030 <__stack_chk_fail@plt>
    2de2:	41 8b 04 24          	mov    eax,DWORD PTR [r12]
    2de6:	48 8d 0d 1b 30 00 00 	lea    rcx,[rip+0x301b]        # 5e08 <_IO_stdin_used+0x1e08>
    2ded:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
    2df1:	48 01 c8             	add    rax,rcx
    2df4:	ff e0                	jmp    rax
    2df6:	49 8b 44 24 08       	mov    rax,QWORD PTR [r12+0x8]
    2dfb:	8b 10                	mov    edx,DWORD PTR [rax]
    2dfd:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
    2e01:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
    2e06:	4c 89 ff             	mov    rdi,r15
    2e09:	e8 32 ff ff ff       	call   2d40 <_count_red$0>
    2e0e:	49 8b 44 24 10       	mov    rax,QWORD PTR [r12+0x10]
    2e13:	8b 10                	mov    edx,DWORD PTR [rax]
    2e15:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
    2e19:	48 89 e6             	mov    rsi,rsp
    2e1c:	4c 89 ff             	mov    rdi,r15
    2e1f:	e8 1c ff ff ff       	call   2d40 <_count_red$0>
    2e24:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
    2e28:	48 03 44 24 08       	add    rax,QWORD PTR [rsp+0x8]
    2e2d:	e9 73 ff ff ff       	jmp    2da5 <_count_red$0+0x65>
    2e32:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    2e39:	00 00 00 
    2e3c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

0000000000002e40 <_loop$0>:
    2e40:	55                   	push   rbp
    2e41:	41 57                	push   r15
    2e43:	41 56                	push   r14
    2e45:	41 55                	push   r13
    2e47:	41 54                	push   r12
    2e49:	53                   	push   rbx
    2e4a:	48 83 ec 48          	sub    rsp,0x48
    2e4e:	48 89 cb             	mov    rbx,rcx
    2e51:	89 d5                	mov    ebp,edx
    2e53:	48 89 74 24 08       	mov    QWORD PTR [rsp+0x8],rsi
    2e58:	49 89 ff             	mov    r15,rdi
    2e5b:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2e62:	00 00 
    2e64:	48 89 44 24 40       	mov    QWORD PTR [rsp+0x40],rax
    2e69:	48 8d 3d 60 33 00 00 	lea    rdi,[rip+0x3360]        # 61d0 <_IO_stdin_used+0x21d0>
    2e70:	48 8d 74 24 38       	lea    rsi,[rsp+0x38]
    2e75:	31 c0                	xor    eax,eax
    2e77:	e8 04 e2 ff ff       	call   1080 <__isoc99_scanf@plt>
    2e7c:	83 f8 01             	cmp    eax,0x1
    2e7f:	0f 85 74 00 00 00    	jne    2ef9 <_loop$0+0xb9>
    2e85:	4c 8d 74 24 10       	lea    r14,[rsp+0x10]
    2e8a:	4c 8d 25 3f 33 00 00 	lea    r12,[rip+0x333f]        # 61d0 <_IO_stdin_used+0x21d0>
    2e91:	4c 8d 6c 24 38       	lea    r13,[rsp+0x38]
    2e96:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    2e9d:	00 00 00 
    2ea0:	48 8b 54 24 38       	mov    rdx,QWORD PTR [rsp+0x38]
    2ea5:	48 85 d2             	test   rdx,rdx
    2ea8:	74 59                	je     2f03 <_loop$0+0xc3>
    2eaa:	49 8b 7f 18          	mov    rdi,QWORD PTR [r15+0x18]
    2eae:	48 8d 74 24 30       	lea    rsi,[rsp+0x30]
    2eb3:	31 c0                	xor    eax,eax
    2eb5:	ff 17                	call   QWORD PTR [rdi]
    2eb7:	48 8b 7c 24 30       	mov    rdi,QWORD PTR [rsp+0x30]
    2ebc:	48 8d 74 24 20       	lea    rsi,[rsp+0x20]
    2ec1:	89 ea                	mov    edx,ebp
    2ec3:	48 89 d9             	mov    rcx,rbx
    2ec6:	31 c0                	xor    eax,eax
    2ec8:	ff 17                	call   QWORD PTR [rdi]
    2eca:	49 8b 7f 08          	mov    rdi,QWORD PTR [r15+0x8]
    2ece:	8b 54 24 20          	mov    edx,DWORD PTR [rsp+0x20]
    2ed2:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
    2ed7:	4c 89 f6             	mov    rsi,r14
    2eda:	31 c0                	xor    eax,eax
    2edc:	ff 17                	call   QWORD PTR [rdi]
    2ede:	8b 6c 24 10          	mov    ebp,DWORD PTR [rsp+0x10]
    2ee2:	48 8b 5c 24 18       	mov    rbx,QWORD PTR [rsp+0x18]
    2ee7:	4c 89 e7             	mov    rdi,r12
    2eea:	4c 89 ee             	mov    rsi,r13
    2eed:	31 c0                	xor    eax,eax
    2eef:	e8 8c e1 ff ff       	call   1080 <__isoc99_scanf@plt>
    2ef4:	83 f8 01             	cmp    eax,0x1
    2ef7:	74 a7                	je     2ea0 <_loop$0+0x60>
    2ef9:	bf 01 00 00 00       	mov    edi,0x1
    2efe:	e8 8d e1 ff ff       	call   1090 <exit@plt>
    2f03:	49 8b 7f 10          	mov    rdi,QWORD PTR [r15+0x10]
    2f07:	48 8b 74 24 08       	mov    rsi,QWORD PTR [rsp+0x8]
    2f0c:	89 ea                	mov    edx,ebp
    2f0e:	48 89 d9             	mov    rcx,rbx
    2f11:	31 c0                	xor    eax,eax
    2f13:	ff 17                	call   QWORD PTR [rdi]
    2f15:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2f1c:	00 00 
    2f1e:	48 3b 44 24 40       	cmp    rax,QWORD PTR [rsp+0x40]
    2f23:	75 0f                	jne    2f34 <_loop$0+0xf4>
    2f25:	48 83 c4 48          	add    rsp,0x48
    2f29:	5b                   	pop    rbx
    2f2a:	41 5c                	pop    r12
    2f2c:	41 5d                	pop    r13
    2f2e:	41 5e                	pop    r14
    2f30:	41 5f                	pop    r15
    2f32:	5d                   	pop    rbp
    2f33:	c3                   	ret    
    2f34:	e8 f7 e0 ff ff       	call   1030 <__stack_chk_fail@plt>
    2f39:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000002f40 <main>:
    2f40:	48 83 ec 18          	sub    rsp,0x18
    2f44:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2f4b:	00 00 
    2f4d:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
    2f52:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
    2f57:	e8 04 e1 ff ff       	call   1060 <time@plt>
    2f5c:	89 c7                	mov    edi,eax
    2f5e:	e8 dd e0 ff ff       	call   1040 <srand@plt>
    2f63:	48 89 e6             	mov    rsi,rsp
    2f66:	e8 85 e2 ff ff       	call   11f0 <___main>
    2f6b:	48 8b 05 66 50 00 00 	mov    rax,QWORD PTR [rip+0x5066]        # 7fd8 <stdout@GLIBC_2.2.5>
    2f72:	48 8b 38             	mov    rdi,QWORD PTR [rax]
    2f75:	48 8b 14 24          	mov    rdx,QWORD PTR [rsp]
    2f79:	48 8d 35 50 32 00 00 	lea    rsi,[rip+0x3250]        # 61d0 <_IO_stdin_used+0x21d0>
    2f80:	31 c0                	xor    eax,eax
    2f82:	e8 c9 e0 ff ff       	call   1050 <fprintf@plt>
    2f87:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2f8e:	00 00 
    2f90:	48 3b 44 24 10       	cmp    rax,QWORD PTR [rsp+0x10]
    2f95:	75 07                	jne    2f9e <main+0x5e>
    2f97:	31 c0                	xor    eax,eax
    2f99:	48 83 c4 18          	add    rsp,0x18
    2f9d:	c3                   	ret    
    2f9e:	e8 8d e0 ff ff       	call   1030 <__stack_chk_fail@plt>
    2fa3:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    2faa:	00 00 00 
    2fad:	0f 1f 00             	nop    DWORD PTR [rax]

0000000000002fb0 <__libc_csu_init>:
    2fb0:	f3 0f 1e fa          	endbr64 
    2fb4:	41 57                	push   r15
    2fb6:	4c 8d 3d e3 4d 00 00 	lea    r15,[rip+0x4de3]        # 7da0 <__frame_dummy_init_array_entry>
    2fbd:	41 56                	push   r14
    2fbf:	49 89 d6             	mov    r14,rdx
    2fc2:	41 55                	push   r13
    2fc4:	49 89 f5             	mov    r13,rsi
    2fc7:	41 54                	push   r12
    2fc9:	41 89 fc             	mov    r12d,edi
    2fcc:	55                   	push   rbp
    2fcd:	48 8d 2d dc 4d 00 00 	lea    rbp,[rip+0x4ddc]        # 7db0 <__do_global_dtors_aux_fini_array_entry>
    2fd4:	53                   	push   rbx
    2fd5:	4c 29 fd             	sub    rbp,r15
    2fd8:	48 83 ec 08          	sub    rsp,0x8
    2fdc:	e8 1f e0 ff ff       	call   1000 <_init>
    2fe1:	48 c1 fd 03          	sar    rbp,0x3
    2fe5:	74 1f                	je     3006 <__libc_csu_init+0x56>
    2fe7:	31 db                	xor    ebx,ebx
    2fe9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    2ff0:	4c 89 f2             	mov    rdx,r14
    2ff3:	4c 89 ee             	mov    rsi,r13
    2ff6:	44 89 e7             	mov    edi,r12d
    2ff9:	41 ff 14 df          	call   QWORD PTR [r15+rbx*8]
    2ffd:	48 83 c3 01          	add    rbx,0x1
    3001:	48 39 dd             	cmp    rbp,rbx
    3004:	75 ea                	jne    2ff0 <__libc_csu_init+0x40>
    3006:	48 83 c4 08          	add    rsp,0x8
    300a:	5b                   	pop    rbx
    300b:	5d                   	pop    rbp
    300c:	41 5c                	pop    r12
    300e:	41 5d                	pop    r13
    3010:	41 5e                	pop    r14
    3012:	41 5f                	pop    r15
    3014:	c3                   	ret    
    3015:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    301c:	00 00 00 00 

0000000000003020 <__libc_csu_fini>:
    3020:	f3 0f 1e fa          	endbr64 
    3024:	c3                   	ret    

Disassembly of section .fini:

0000000000003028 <_fini>:
    3028:	f3 0f 1e fa          	endbr64 
    302c:	48 83 ec 08          	sub    rsp,0x8
    3030:	48 83 c4 08          	add    rsp,0x8
    3034:	c3                   	ret    
