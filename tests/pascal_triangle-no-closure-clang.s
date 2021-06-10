
tests/pascal_triangle-no-closure-clang.exe:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	f3 0f 1e fa          	endbr64 
    1004:	48 83 ec 08          	sub    rsp,0x8
    1008:	48 8b 05 d9 2f 00 00 	mov    rax,QWORD PTR [rip+0x2fd9]        # 3fe8 <__gmon_start__>
    100f:	48 85 c0             	test   rax,rax
    1012:	74 02                	je     1016 <_init+0x16>
    1014:	ff d0                	call   rax
    1016:	48 83 c4 08          	add    rsp,0x8
    101a:	c3                   	ret    

Disassembly of section .plt:

0000000000001020 <__stack_chk_fail@plt-0x10>:
    1020:	ff 35 e2 2f 00 00    	push   QWORD PTR [rip+0x2fe2]        # 4008 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	ff 25 e4 2f 00 00    	jmp    QWORD PTR [rip+0x2fe4]        # 4010 <_GLOBAL_OFFSET_TABLE_+0x10>
    102c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

0000000000001030 <__stack_chk_fail@plt>:
    1030:	ff 25 e2 2f 00 00    	jmp    QWORD PTR [rip+0x2fe2]        # 4018 <__stack_chk_fail@GLIBC_2.4>
    1036:	68 00 00 00 00       	push   0x0
    103b:	e9 e0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001040 <srand@plt>:
    1040:	ff 25 da 2f 00 00    	jmp    QWORD PTR [rip+0x2fda]        # 4020 <srand@GLIBC_2.2.5>
    1046:	68 01 00 00 00       	push   0x1
    104b:	e9 d0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001050 <fprintf@plt>:
    1050:	ff 25 d2 2f 00 00    	jmp    QWORD PTR [rip+0x2fd2]        # 4028 <fprintf@GLIBC_2.2.5>
    1056:	68 02 00 00 00       	push   0x2
    105b:	e9 c0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001060 <time@plt>:
    1060:	ff 25 ca 2f 00 00    	jmp    QWORD PTR [rip+0x2fca]        # 4030 <time@GLIBC_2.2.5>
    1066:	68 03 00 00 00       	push   0x3
    106b:	e9 b0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001070 <__isoc99_scanf@plt>:
    1070:	ff 25 c2 2f 00 00    	jmp    QWORD PTR [rip+0x2fc2]        # 4038 <__isoc99_scanf@GLIBC_2.7>
    1076:	68 04 00 00 00       	push   0x4
    107b:	e9 a0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001080 <exit@plt>:
    1080:	ff 25 ba 2f 00 00    	jmp    QWORD PTR [rip+0x2fba]        # 4040 <exit@GLIBC_2.2.5>
    1086:	68 05 00 00 00       	push   0x5
    108b:	e9 90 ff ff ff       	jmp    1020 <_init+0x20>

Disassembly of section .text:

0000000000001090 <set_fast_math>:
    1090:	f3 0f 1e fa          	endbr64 
    1094:	0f ae 5c 24 fc       	stmxcsr DWORD PTR [rsp-0x4]
    1099:	81 4c 24 fc 40 80 00 	or     DWORD PTR [rsp-0x4],0x8040
    10a0:	00 
    10a1:	0f ae 54 24 fc       	ldmxcsr DWORD PTR [rsp-0x4]
    10a6:	c3                   	ret    
    10a7:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
    10ae:	00 00 

00000000000010b0 <_start>:
    10b0:	f3 0f 1e fa          	endbr64 
    10b4:	31 ed                	xor    ebp,ebp
    10b6:	49 89 d1             	mov    r9,rdx
    10b9:	5e                   	pop    rsi
    10ba:	48 89 e2             	mov    rdx,rsp
    10bd:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
    10c1:	50                   	push   rax
    10c2:	54                   	push   rsp
    10c3:	4c 8d 05 56 03 00 00 	lea    r8,[rip+0x356]        # 1420 <__libc_csu_fini>
    10ca:	48 8d 0d df 02 00 00 	lea    rcx,[rip+0x2df]        # 13b0 <__libc_csu_init>
    10d1:	48 8d 3d 28 02 00 00 	lea    rdi,[rip+0x228]        # 1300 <main>
    10d8:	ff 15 02 2f 00 00    	call   QWORD PTR [rip+0x2f02]        # 3fe0 <__libc_start_main@GLIBC_2.2.5>
    10de:	f4                   	hlt    
    10df:	90                   	nop

00000000000010e0 <deregister_tm_clones>:
    10e0:	48 8d 3d 71 2f 00 00 	lea    rdi,[rip+0x2f71]        # 4058 <__TMC_END__>
    10e7:	48 8d 05 6a 2f 00 00 	lea    rax,[rip+0x2f6a]        # 4058 <__TMC_END__>
    10ee:	48 39 f8             	cmp    rax,rdi
    10f1:	74 15                	je     1108 <deregister_tm_clones+0x28>
    10f3:	48 8b 05 d6 2e 00 00 	mov    rax,QWORD PTR [rip+0x2ed6]        # 3fd0 <_ITM_deregisterTMCloneTable>
    10fa:	48 85 c0             	test   rax,rax
    10fd:	74 09                	je     1108 <deregister_tm_clones+0x28>
    10ff:	ff e0                	jmp    rax
    1101:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    1108:	c3                   	ret    
    1109:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001110 <register_tm_clones>:
    1110:	48 8d 3d 41 2f 00 00 	lea    rdi,[rip+0x2f41]        # 4058 <__TMC_END__>
    1117:	48 8d 35 3a 2f 00 00 	lea    rsi,[rip+0x2f3a]        # 4058 <__TMC_END__>
    111e:	48 29 fe             	sub    rsi,rdi
    1121:	48 89 f0             	mov    rax,rsi
    1124:	48 c1 ee 3f          	shr    rsi,0x3f
    1128:	48 c1 f8 03          	sar    rax,0x3
    112c:	48 01 c6             	add    rsi,rax
    112f:	48 d1 fe             	sar    rsi,1
    1132:	74 14                	je     1148 <register_tm_clones+0x38>
    1134:	48 8b 05 b5 2e 00 00 	mov    rax,QWORD PTR [rip+0x2eb5]        # 3ff0 <_ITM_registerTMCloneTable>
    113b:	48 85 c0             	test   rax,rax
    113e:	74 08                	je     1148 <register_tm_clones+0x38>
    1140:	ff e0                	jmp    rax
    1142:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    1148:	c3                   	ret    
    1149:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001150 <__do_global_dtors_aux>:
    1150:	f3 0f 1e fa          	endbr64 
    1154:	80 3d fd 2e 00 00 00 	cmp    BYTE PTR [rip+0x2efd],0x0        # 4058 <__TMC_END__>
    115b:	75 33                	jne    1190 <__do_global_dtors_aux+0x40>
    115d:	55                   	push   rbp
    115e:	48 83 3d 92 2e 00 00 	cmp    QWORD PTR [rip+0x2e92],0x0        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    1165:	00 
    1166:	48 89 e5             	mov    rbp,rsp
    1169:	74 0d                	je     1178 <__do_global_dtors_aux+0x28>
    116b:	48 8b 3d de 2e 00 00 	mov    rdi,QWORD PTR [rip+0x2ede]        # 4050 <__dso_handle>
    1172:	ff 15 80 2e 00 00    	call   QWORD PTR [rip+0x2e80]        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    1178:	e8 63 ff ff ff       	call   10e0 <deregister_tm_clones>
    117d:	c6 05 d4 2e 00 00 01 	mov    BYTE PTR [rip+0x2ed4],0x1        # 4058 <__TMC_END__>
    1184:	5d                   	pop    rbp
    1185:	c3                   	ret    
    1186:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    118d:	00 00 00 
    1190:	c3                   	ret    
    1191:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    1198:	00 00 00 00 
    119c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

00000000000011a0 <frame_dummy>:
    11a0:	f3 0f 1e fa          	endbr64 
    11a4:	e9 67 ff ff ff       	jmp    1110 <register_tm_clones>
    11a9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

00000000000011b0 <__input>:
    11b0:	50                   	push   rax
    11b1:	48 89 fe             	mov    rsi,rdi
    11b4:	48 8d 3d 49 0e 00 00 	lea    rdi,[rip+0xe49]        # 2004 <_IO_stdin_used+0x4>
    11bb:	31 c0                	xor    eax,eax
    11bd:	e8 ae fe ff ff       	call   1070 <__isoc99_scanf@plt>
    11c2:	83 f8 01             	cmp    eax,0x1
    11c5:	75 02                	jne    11c9 <__input+0x19>
    11c7:	58                   	pop    rax
    11c8:	c3                   	ret    
    11c9:	bf 01 00 00 00       	mov    edi,0x1
    11ce:	e8 ad fe ff ff       	call   1080 <exit@plt>
    11d3:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    11da:	00 00 00 
    11dd:	0f 1f 00             	nop    DWORD PTR [rax]

00000000000011e0 <___main>:
    11e0:	53                   	push   rbx
    11e1:	48 83 ec 20          	sub    rsp,0x20
    11e5:	48 89 f3             	mov    rbx,rsi
    11e8:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    11ef:	00 00 
    11f1:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
    11f6:	48 8d 3d 07 0e 00 00 	lea    rdi,[rip+0xe07]        # 2004 <_IO_stdin_used+0x4>
    11fd:	48 8d 74 24 10       	lea    rsi,[rsp+0x10]
    1202:	31 c0                	xor    eax,eax
    1204:	e8 67 fe ff ff       	call   1070 <__isoc99_scanf@plt>
    1209:	83 f8 01             	cmp    eax,0x1
    120c:	75 47                	jne    1255 <___main+0x75>
    120e:	48 8d 3d ef 0d 00 00 	lea    rdi,[rip+0xdef]        # 2004 <_IO_stdin_used+0x4>
    1215:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
    121a:	31 c0                	xor    eax,eax
    121c:	e8 4f fe ff ff       	call   1070 <__isoc99_scanf@plt>
    1221:	83 f8 01             	cmp    eax,0x1
    1224:	75 2f                	jne    1255 <___main+0x75>
    1226:	48 8b 4c 24 08       	mov    rcx,QWORD PTR [rsp+0x8]
    122b:	48 8b 54 24 10       	mov    rdx,QWORD PTR [rsp+0x10]
    1230:	48 8d 3d a1 2b 00 00 	lea    rdi,[rip+0x2ba1]        # 3dd8 <___main._getNumber$0$>
    1237:	48 89 de             	mov    rsi,rbx
    123a:	e8 31 00 00 00       	call   1270 <_getNumber$0>
    123f:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    1246:	00 00 
    1248:	48 3b 44 24 18       	cmp    rax,QWORD PTR [rsp+0x18]
    124d:	75 10                	jne    125f <___main+0x7f>
    124f:	48 83 c4 20          	add    rsp,0x20
    1253:	5b                   	pop    rbx
    1254:	c3                   	ret    
    1255:	bf 01 00 00 00       	mov    edi,0x1
    125a:	e8 21 fe ff ff       	call   1080 <exit@plt>
    125f:	e8 cc fd ff ff       	call   1030 <__stack_chk_fail@plt>
    1264:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    126b:	00 00 00 
    126e:	66 90                	xchg   ax,ax

0000000000001270 <_getNumber$0>:
    1270:	41 57                	push   r15
    1272:	41 56                	push   r14
    1274:	41 54                	push   r12
    1276:	53                   	push   rbx
    1277:	48 83 ec 18          	sub    rsp,0x18
    127b:	49 89 f6             	mov    r14,rsi
    127e:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    1285:	00 00 
    1287:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
    128c:	b8 01 00 00 00       	mov    eax,0x1
    1291:	48 39 d1             	cmp    rcx,rdx
    1294:	74 42                	je     12d8 <_getNumber$0+0x68>
    1296:	48 89 d3             	mov    rbx,rdx
    1299:	48 85 d2             	test   rdx,rdx
    129c:	74 3a                	je     12d8 <_getNumber$0+0x68>
    129e:	49 89 cf             	mov    r15,rcx
    12a1:	48 85 c9             	test   rcx,rcx
    12a4:	74 32                	je     12d8 <_getNumber$0+0x68>
    12a6:	49 89 fc             	mov    r12,rdi
    12a9:	48 83 c3 ff          	add    rbx,0xffffffffffffffff
    12ad:	49 8d 4f ff          	lea    rcx,[r15-0x1]
    12b1:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
    12b6:	48 89 da             	mov    rdx,rbx
    12b9:	e8 b2 ff ff ff       	call   1270 <_getNumber$0>
    12be:	48 89 e6             	mov    rsi,rsp
    12c1:	4c 89 e7             	mov    rdi,r12
    12c4:	48 89 da             	mov    rdx,rbx
    12c7:	4c 89 f9             	mov    rcx,r15
    12ca:	e8 a1 ff ff ff       	call   1270 <_getNumber$0>
    12cf:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
    12d3:	48 03 44 24 08       	add    rax,QWORD PTR [rsp+0x8]
    12d8:	49 89 06             	mov    QWORD PTR [r14],rax
    12db:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    12e2:	00 00 
    12e4:	48 3b 44 24 10       	cmp    rax,QWORD PTR [rsp+0x10]
    12e9:	75 0c                	jne    12f7 <_getNumber$0+0x87>
    12eb:	48 83 c4 18          	add    rsp,0x18
    12ef:	5b                   	pop    rbx
    12f0:	41 5c                	pop    r12
    12f2:	41 5e                	pop    r14
    12f4:	41 5f                	pop    r15
    12f6:	c3                   	ret    
    12f7:	e8 34 fd ff ff       	call   1030 <__stack_chk_fail@plt>
    12fc:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

0000000000001300 <main>:
    1300:	48 83 ec 28          	sub    rsp,0x28
    1304:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    130b:	00 00 
    130d:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
    1312:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
    1317:	e8 44 fd ff ff       	call   1060 <time@plt>
    131c:	89 c7                	mov    edi,eax
    131e:	e8 1d fd ff ff       	call   1040 <srand@plt>
    1323:	48 8d 3d da 0c 00 00 	lea    rdi,[rip+0xcda]        # 2004 <_IO_stdin_used+0x4>
    132a:	48 8d 74 24 18       	lea    rsi,[rsp+0x18]
    132f:	31 c0                	xor    eax,eax
    1331:	e8 3a fd ff ff       	call   1070 <__isoc99_scanf@plt>
    1336:	83 f8 01             	cmp    eax,0x1
    1339:	75 64                	jne    139f <main+0x9f>
    133b:	48 8d 3d c2 0c 00 00 	lea    rdi,[rip+0xcc2]        # 2004 <_IO_stdin_used+0x4>
    1342:	48 8d 74 24 10       	lea    rsi,[rsp+0x10]
    1347:	31 c0                	xor    eax,eax
    1349:	e8 22 fd ff ff       	call   1070 <__isoc99_scanf@plt>
    134e:	83 f8 01             	cmp    eax,0x1
    1351:	75 4c                	jne    139f <main+0x9f>
    1353:	48 8b 4c 24 10       	mov    rcx,QWORD PTR [rsp+0x10]
    1358:	48 8b 54 24 18       	mov    rdx,QWORD PTR [rsp+0x18]
    135d:	48 8d 3d 74 2a 00 00 	lea    rdi,[rip+0x2a74]        # 3dd8 <___main._getNumber$0$>
    1364:	48 89 e6             	mov    rsi,rsp
    1367:	e8 04 ff ff ff       	call   1270 <_getNumber$0>
    136c:	48 8b 05 65 2c 00 00 	mov    rax,QWORD PTR [rip+0x2c65]        # 3fd8 <stdout@GLIBC_2.2.5>
    1373:	48 8b 38             	mov    rdi,QWORD PTR [rax]
    1376:	48 8b 14 24          	mov    rdx,QWORD PTR [rsp]
    137a:	48 8d 35 83 0c 00 00 	lea    rsi,[rip+0xc83]        # 2004 <_IO_stdin_used+0x4>
    1381:	31 c0                	xor    eax,eax
    1383:	e8 c8 fc ff ff       	call   1050 <fprintf@plt>
    1388:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    138f:	00 00 
    1391:	48 3b 44 24 20       	cmp    rax,QWORD PTR [rsp+0x20]
    1396:	75 11                	jne    13a9 <main+0xa9>
    1398:	31 c0                	xor    eax,eax
    139a:	48 83 c4 28          	add    rsp,0x28
    139e:	c3                   	ret    
    139f:	bf 01 00 00 00       	mov    edi,0x1
    13a4:	e8 d7 fc ff ff       	call   1080 <exit@plt>
    13a9:	e8 82 fc ff ff       	call   1030 <__stack_chk_fail@plt>
    13ae:	66 90                	xchg   ax,ax

00000000000013b0 <__libc_csu_init>:
    13b0:	f3 0f 1e fa          	endbr64 
    13b4:	41 57                	push   r15
    13b6:	4c 8d 3d 03 2a 00 00 	lea    r15,[rip+0x2a03]        # 3dc0 <__frame_dummy_init_array_entry>
    13bd:	41 56                	push   r14
    13bf:	49 89 d6             	mov    r14,rdx
    13c2:	41 55                	push   r13
    13c4:	49 89 f5             	mov    r13,rsi
    13c7:	41 54                	push   r12
    13c9:	41 89 fc             	mov    r12d,edi
    13cc:	55                   	push   rbp
    13cd:	48 8d 2d fc 29 00 00 	lea    rbp,[rip+0x29fc]        # 3dd0 <__do_global_dtors_aux_fini_array_entry>
    13d4:	53                   	push   rbx
    13d5:	4c 29 fd             	sub    rbp,r15
    13d8:	48 83 ec 08          	sub    rsp,0x8
    13dc:	e8 1f fc ff ff       	call   1000 <_init>
    13e1:	48 c1 fd 03          	sar    rbp,0x3
    13e5:	74 1f                	je     1406 <__libc_csu_init+0x56>
    13e7:	31 db                	xor    ebx,ebx
    13e9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    13f0:	4c 89 f2             	mov    rdx,r14
    13f3:	4c 89 ee             	mov    rsi,r13
    13f6:	44 89 e7             	mov    edi,r12d
    13f9:	41 ff 14 df          	call   QWORD PTR [r15+rbx*8]
    13fd:	48 83 c3 01          	add    rbx,0x1
    1401:	48 39 dd             	cmp    rbp,rbx
    1404:	75 ea                	jne    13f0 <__libc_csu_init+0x40>
    1406:	48 83 c4 08          	add    rsp,0x8
    140a:	5b                   	pop    rbx
    140b:	5d                   	pop    rbp
    140c:	41 5c                	pop    r12
    140e:	41 5d                	pop    r13
    1410:	41 5e                	pop    r14
    1412:	41 5f                	pop    r15
    1414:	c3                   	ret    
    1415:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    141c:	00 00 00 00 

0000000000001420 <__libc_csu_fini>:
    1420:	f3 0f 1e fa          	endbr64 
    1424:	c3                   	ret    

Disassembly of section .fini:

0000000000001428 <_fini>:
    1428:	f3 0f 1e fa          	endbr64 
    142c:	48 83 ec 08          	sub    rsp,0x8
    1430:	48 83 c4 08          	add    rsp,0x8
    1434:	c3                   	ret    
