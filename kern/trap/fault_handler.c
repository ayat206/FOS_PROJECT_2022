/*
 * fault_handler.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include "trap.h"
#include <kern/proc/user_environment.h>
#include "../cpu/sched.h"
#include "../disk/pagefile_manager.h"
#include "../mem/memory_manager.h"

//2014 Test Free(): Set it to bypass the PAGE FAULT on an instruction with this length and continue executing the next one
// 0 means don't bypass the PAGE FAULT
uint8 bypassInstrLength = 0;

//===============================
// REPLACEMENT STRATEGIES
//===============================
//2020
void setPageReplacmentAlgorithmLRU(int LRU_TYPE)
{
	assert(LRU_TYPE == PG_REP_LRU_TIME_APPROX || LRU_TYPE == PG_REP_LRU_LISTS_APPROX);
	_PageRepAlgoType = LRU_TYPE ;
}
void setPageReplacmentAlgorithmCLOCK(){_PageRepAlgoType = PG_REP_CLOCK;}
void setPageReplacmentAlgorithmFIFO(){_PageRepAlgoType = PG_REP_FIFO;}
void setPageReplacmentAlgorithmModifiedCLOCK(){_PageRepAlgoType = PG_REP_MODIFIEDCLOCK;}
/*2018*/ void setPageReplacmentAlgorithmDynamicLocal(){_PageRepAlgoType = PG_REP_DYNAMIC_LOCAL;}
/*2021*/ void setPageReplacmentAlgorithmNchanceCLOCK(int PageWSMaxSweeps){_PageRepAlgoType = PG_REP_NchanceCLOCK;  page_WS_max_sweeps = PageWSMaxSweeps;}

//2020
uint32 isPageReplacmentAlgorithmLRU(int LRU_TYPE){return _PageRepAlgoType == LRU_TYPE ? 1 : 0;}
uint32 isPageReplacmentAlgorithmCLOCK(){if(_PageRepAlgoType == PG_REP_CLOCK) return 1; return 0;}
uint32 isPageReplacmentAlgorithmFIFO(){if(_PageRepAlgoType == PG_REP_FIFO) return 1; return 0;}
uint32 isPageReplacmentAlgorithmModifiedCLOCK(){if(_PageRepAlgoType == PG_REP_MODIFIEDCLOCK) return 1; return 0;}
/*2018*/ uint32 isPageReplacmentAlgorithmDynamicLocal(){if(_PageRepAlgoType == PG_REP_DYNAMIC_LOCAL) return 1; return 0;}
/*2021*/ uint32 isPageReplacmentAlgorithmNchanceCLOCK(){if(_PageRepAlgoType == PG_REP_NchanceCLOCK) return 1; return 0;}

//===============================
// PAGE BUFFERING
//===============================
void enableModifiedBuffer(uint32 enableIt){_EnableModifiedBuffer = enableIt;}
uint8 isModifiedBufferEnabled(){  return _EnableModifiedBuffer ; }

void enableBuffering(uint32 enableIt){_EnableBuffering = enableIt;}
uint8 isBufferingEnabled(){  return _EnableBuffering ; }

void setModifiedBufferLength(uint32 length) { _ModifiedBufferLength = length;}
uint32 getModifiedBufferLength() { return _ModifiedBufferLength;}

//===============================
// FAULT HANDLERS
//===============================

//Handle the table fault
void table_fault_handler(struct Env * curenv, uint32 fault_va)
{
	//panic("table_fault_handler() is not implemented yet...!!");
	//Check if it's a stack page
	uint32* ptr_table;
#if USE_KHEAP
	{
		ptr_table = create_page_table(curenv->env_page_directory, (uint32)fault_va);
	}
#else
	{
		__static_cpt(curenv->env_page_directory, (uint32)fault_va, &ptr_table);
	}
#endif
}

//Handle the page fault

void placment(struct Env * curenv, uint32 fault_va){
	uint32 *ptr_table = NULL;
		uint32 last_index =curenv->page_last_WS_index;
		unsigned int ret = env_page_ws_get_size(curenv);
		struct FrameInfo* ptr ;
		if (ret < curenv->page_WS_max_size)
		{
			//cprintf("======= Placement of va = %x \n ",fault_va);
			allocate_frame(&ptr);
			map_frame(curenv->env_page_directory, ptr, fault_va,PERM_MODIFIED |PERM_WRITEABLE | PERM_USER);
			int ret_page = pf_read_env_page(curenv, (void*)fault_va);
			if (ret_page ==0)
			{
				env_page_ws_set_entry(curenv, last_index, fault_va);
				curenv->page_last_WS_index++;
			}
			else if (ret_page == E_PAGE_NOT_EXIST_IN_PF)
			{
				if ((fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX) || (fault_va >= USTACKBOTTOM && fault_va < USTACKTOP))
				{
					env_page_ws_set_entry(curenv, last_index, fault_va);
					curenv->page_last_WS_index++;
				}
				else
				{
					unmap_frame(curenv->env_page_directory, fault_va);
					panic("ILLEGAL MEMORY ACCESS !!");
				}
			}
			if(curenv->page_last_WS_index==curenv->page_WS_max_size)
			{
				curenv->page_last_WS_index=0;
			}
		}
}

void page_fault_handler(struct Env * curenv, uint32 fault_va)
{
	//TODO: [PROJECT MS3] [FAULT HANDLER] page_fault_handler
	// Write your code here, remove the panic and write your code
	//panic("page_fault_handler() is not implemented yet...!!");

	//uint32 *ptr_table = NULL;
	uint32 last_index =curenv->page_last_WS_index;
	unsigned int ret = env_page_ws_get_size(curenv);
	struct FrameInfo* ptr ;
	if (ret < curenv->page_WS_max_size)
	{
		//cprintf("======= Placement of va = %x \n ",fault_va);
		allocate_frame(&ptr);
		map_frame(curenv->env_page_directory, ptr, fault_va,PERM_MODIFIED |PERM_WRITEABLE | PERM_USER);
		int ret_page = pf_read_env_page(curenv, (void*)fault_va);
		if (ret_page ==0)
		{
			env_page_ws_set_entry(curenv, last_index, fault_va);
			curenv->page_last_WS_index++;
		}
		else if (ret_page == E_PAGE_NOT_EXIST_IN_PF)
		{
			if ((fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX) || (fault_va >= USTACKBOTTOM && fault_va < USTACKTOP))
			{
				env_page_ws_set_entry(curenv, last_index, fault_va);
				curenv->page_last_WS_index++;
			}
			else
			{
				unmap_frame(curenv->env_page_directory, fault_va);
				panic("ILLEGAL MEMORY ACCESS !!");
			}
		}
		if(curenv->page_last_WS_index==curenv->page_WS_max_size)
		{
			curenv->page_last_WS_index=0;
		}
	}
	else
	{
		//cprintf("======= curent index = %x \n ",curenv->page_last_WS_index);
		bool amira =1;
		while(amira==1){
	    int flag=0;
		uint32 *ptr_bb = NULL;
		for (int i =curenv->page_last_WS_index; i < curenv->page_WS_max_size; i++)
		{
			uint32 vitual_add = env_page_ws_get_virtual_address(curenv, i);
			struct FrameInfo* ptr_rep = get_frame_info(curenv->env_page_directory, vitual_add, &ptr_bb);
			uint32 permisstin_111= pt_get_page_permissions(curenv->env_page_directory, vitual_add);

			if ((permisstin_111&PERM_USED) != PERM_USED)
			{
				//cprintf("0");
				if ((permisstin_111&PERM_MODIFIED) != PERM_MODIFIED)
				{
					//cprintf("1");
					env_page_ws_clear_entry(curenv, i);
					unmap_frame(curenv->env_page_directory, vitual_add);
					curenv->page_last_WS_index=i;
					placment(curenv,fault_va);
					flag=1;
					amira=0;
					break;
				}
				else
				{
					//cprintf("2");
					pf_update_env_page(curenv, vitual_add, ptr_rep);
					env_page_ws_clear_entry(curenv, i);
					unmap_frame(curenv->env_page_directory, vitual_add);
					flag=1;
					curenv->page_last_WS_index=i;
					placment(curenv,fault_va);
					amira=0;
					break;
				}
			}
			else
			{
				pt_set_page_permissions(curenv->env_page_directory, vitual_add, 0, PERM_USED);
			}
		}
		if(flag==0)
		{
			for(int i=0; i <curenv->page_last_WS_index;i++)
			{
				uint32 *ptr4;
				uint32 vitual_add1 = env_page_ws_get_virtual_address(curenv, i);
				struct FrameInfo* ptr_rep1 = get_frame_info(curenv->env_page_directory, vitual_add1, &ptr4);
				uint32 permisstin_1111= pt_get_page_permissions(curenv->env_page_directory, vitual_add1);

				if ((permisstin_1111&PERM_USED) != PERM_USED)
				{
					if ((permisstin_1111&PERM_MODIFIED) != PERM_MODIFIED)
					{
						env_page_ws_clear_entry(curenv, i);
						unmap_frame(curenv->env_page_directory, vitual_add1);
						curenv->page_last_WS_index=i;
						placment(curenv,fault_va);
						amira=0;
						break;
					}
					else
					{
						pf_update_env_page(curenv, vitual_add1, ptr_rep1);
						env_page_ws_clear_entry(curenv, i);
						unmap_frame(curenv->env_page_directory, vitual_add1);
						curenv->page_last_WS_index=i;
						placment(curenv,fault_va);
						amira=0;
						break;
					}
				}
				else
				{
					pt_set_page_permissions(curenv->env_page_directory, vitual_add1, 0, PERM_USED);
				}
			}
		}
	}
	}
	//refer to the project presentation and documentation for details
}

void __page_fault_handler_with_buffering(struct Env * curenv, uint32 fault_va)
{
	// Write your code here, remove the panic and write your code
	panic("__page_fault_handler_with_buffering() is not implemented yet...!!");


}
