/*
 * chunk_operations.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include <kern/trap/fault_handler.h>
#include <kern/disk/pagefile_manager.h>
#include "kheap.h"
#include "memory_manager.h"


/******************************/
/*[1] RAM CHUNKS MANIPULATION */
/******************************/

//===============================
// 1) CUT-PASTE PAGES IN RAM:
//===============================
//This function should cut-paste the given number of pages from source_va to dest_va
//if the page table at any destination page in the range is not exist, it should create it
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int cut_paste_pages(uint32* page_directory, uint32 source_va, uint32 dest_va, uint32 num_of_pages)
{
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] cut_paste_pages
	// Write your code here, remove the panic and write your code
	//panic("cut_paste_pages() is not implemented yet...!!");

	//int debug = source_va == 0x2800000 && dest_va == 0x2900000 && num_of_pages == 3;
	source_va = ROUNDDOWN(source_va, PAGE_SIZE);
	dest_va = ROUNDDOWN(dest_va, PAGE_SIZE);
	uint32 destVa279 = dest_va;
	uint32 *ptr_page_table_34an_elsource = NULL;
	uint32 *ptr_page_table_34an_eldestination = NULL;
	uint32 *ptr_page_table3 = NULL;
	uint32 *aa7= NULL;
	struct FrameInfo* Return_From_Destination = NULL;
	struct FrameInfo *ptr_frame_info = NULL;

	for(int counter = 0; counter < num_of_pages; counter++)
	{
		Return_From_Destination = get_frame_info(page_directory, destVa279, &aa7);
		if(Return_From_Destination != NULL)
			return -1;
		destVa279+=PAGE_SIZE;
	}

	for(int counter = 0; counter < num_of_pages; counter++)
	{
		get_page_table(page_directory, dest_va, &ptr_page_table_34an_eldestination);

		if (ptr_page_table_34an_eldestination == NULL)
			ptr_page_table_34an_eldestination = create_page_table(page_directory, dest_va);

		get_page_table(page_directory, source_va, &ptr_page_table_34an_elsource);

		int El_permissions_bta3t_elsource = ptr_page_table_34an_elsource[PTX(source_va)] & 0XFFF;

		ptr_frame_info = get_frame_info(page_directory, source_va, &ptr_page_table3);
		map_frame(page_directory, ptr_frame_info, dest_va, El_permissions_bta3t_elsource);

		unmap_frame(page_directory, source_va);

		source_va+=PAGE_SIZE;
		dest_va+=PAGE_SIZE;
	}
	return 0;
}

//===============================
// 2) COPY-PASTE RANGE IN RAM:
//===============================
//This function should copy-paste the given size from source_va to dest_va
//if the page table at any destination page in the range is not exist, it should create it
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int copy_paste_chunk(uint32* page_directory, uint32 source_va, uint32 dest_va, uint32 size)
{
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] copy_paste_chunk
	// Write your code here, remove the panic and write your code
	//panic("copy_paste_chunk() is not implemented yet...!!");

	uint32* ptr_page_table_source = NULL;
    uint32* ptr_page_table_dest = NULL;
    struct FrameInfo* ptr_frame_info_dest = NULL;

    for(uint32 i = dest_va; i < dest_va+size; i+=PAGE_SIZE)
    {
    	ptr_frame_info_dest= get_frame_info(page_directory,i,&ptr_page_table_dest);
    	if(ptr_frame_info_dest != NULL)
    	{
    		uint32 dest_perm = ptr_page_table_dest[PTX(i)] & PERM_WRITEABLE;
    		if(dest_perm != PERM_WRITEABLE)
    			return -1;
    	}
    }

    uint32 source_ptr = source_va;
    for(uint32 i = dest_va; i < dest_va+size; i+=PAGE_SIZE)
    {
    	uint32 ptr_page_table_dest_ret = get_page_table(page_directory,i,&ptr_page_table_dest);
    	if(ptr_page_table_dest_ret != TABLE_IN_MEMORY)
    	{
    		ptr_page_table_dest = create_page_table(page_directory,i);
    	}
    	ptr_frame_info_dest = get_frame_info(page_directory,i,&ptr_page_table_dest);
    	get_page_table(page_directory,source_ptr,&ptr_page_table_source);
    	int source_perm=source_perm=(ptr_page_table_source[PTX(source_ptr)] & PERM_USER);
    	if(ptr_frame_info_dest == NULL)
    	{
    		struct FrameInfo* new_frames = NULL;
    		allocate_frame(&new_frames);
    		get_page_table(page_directory,source_ptr,&ptr_page_table_source);
    		int source_perm=source_perm=(ptr_page_table_source[PTX(source_ptr)] & PERM_USER);
    		map_frame(page_directory,new_frames,i,source_perm|PERM_WRITEABLE);
    	}
    	else
    	{
    		pt_set_page_permissions(page_directory,i,source_perm,0);
    	}
    	source_ptr+=PAGE_SIZE;
    }

    uint32 source = source_va;
    for(uint32 i = dest_va; i < dest_va+size; i++)
    {
    	uint8 *pointer_source = (uint8*)source;
	    uint8 *pointer_dest = (uint8*)i;
	    *pointer_dest = *pointer_source;
	    source++;
    }

   return 0;
}

//===============================
// 3) SHARE RANGE IN RAM:
//===============================
//This function should share the given size from dest_va with the source_va
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int share_chunk(uint32* page_directory, uint32 source_va,uint32 dest_va, uint32 size, uint32 perms)
{
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] share_chunk
	// Write your code here, remove the panic and write your code
	//panic("share_chunk() is not implemented yet...!!");

	uint32 source_en_va = source_va + size;
	uint32 dest_en_va = dest_va + size;
	source_va = ROUNDDOWN(source_va, PAGE_SIZE);
	dest_va = ROUNDDOWN(dest_va, PAGE_SIZE);
	source_en_va = ROUNDUP(source_en_va, PAGE_SIZE);
	dest_en_va = ROUNDUP(dest_en_va, PAGE_SIZE);
	uint32 destva555555555 = dest_va;
	uint32 *ptr_page_table_34an_elsource = NULL;
	uint32 *ptr_page_table_34an_eldestination = NULL;
	uint32 *ptr_page_table3 = NULL;
	uint32 *ptra7a= NULL;
	struct FrameInfo* Return_From_Destination = NULL;
	struct FrameInfo *ptr_frame_info = NULL;
	uint32 newSize = dest_en_va - dest_va ;
	uint32 num_of_pages = newSize / PAGE_SIZE;

	for(int counter = dest_va; counter < dest_en_va; counter+=PAGE_SIZE)
	{
		Return_From_Destination = get_frame_info(page_directory, destva555555555, &ptra7a);
		if(Return_From_Destination != NULL)
			return -1;
		destva555555555+=PAGE_SIZE;
	}

	for(int counter = 0; counter < num_of_pages; counter++)
	{
		get_page_table(page_directory, dest_va, &ptr_page_table_34an_eldestination);

		if (ptr_page_table_34an_eldestination == NULL)
			ptr_page_table_34an_eldestination = create_page_table(page_directory, dest_va);

		get_page_table(page_directory, source_va, &ptr_page_table_34an_elsource);

		int El_permissions_bta3t_elsource = ptr_page_table_34an_elsource[PTX(source_va)] & 0XFFF;

		ptr_frame_info = get_frame_info(page_directory, source_va, &ptr_page_table3);
		map_frame(page_directory, ptr_frame_info, dest_va, perms);

		source_va+=PAGE_SIZE;
		dest_va+=PAGE_SIZE;
	}

	return 0;
}

//===============================
// 4) ALLOCATE CHUNK IN RAM:
//===============================
//This function should allocate in RAM the given range [va, va+size)
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int allocate_chunk(uint32* page_directory, uint32 va, uint32 size, uint32 perms)
{
	//[PROJECT MS2] [CHUNK OPERATIONS] allocate_chunk
	// Write your code here, remove the panic and write your code
	//panic("allocate_chunk() is not implemented yet...!!");
	uint32 sva = ROUNDDOWN(va,PAGE_SIZE);
	uint32 eva = va + size;
	eva = ROUNDUP(eva,PAGE_SIZE);
	struct FrameInfo* ptr = NULL;
	uint32 *ptr_page_table = NULL;

	for(uint32 i = sva; i < eva; i+=PAGE_SIZE)
	{
		ptr = get_frame_info(page_directory,i,&ptr_page_table);
		if (ptr!= NULL)
		{
			return -1;
		}
	}

	for(uint32 i = sva; i<eva; i+=PAGE_SIZE)
	{
		int ret = get_page_table(page_directory, i, &ptr_page_table);
		if (ret ==TABLE_NOT_EXIST)
		{
			create_page_table(page_directory, i);
		}
		allocate_frame(&ptr);
		map_frame(page_directory,ptr,i,perms);
		ptr->va = i;
	}

	return 0;
}

/*BONUS*/
//=====================================
// 5) CALCULATE ALLOCATED SPACE IN RAM:
//=====================================
void calculate_allocated_space(uint32* page_directory, uint32 sva, uint32 eva, uint32 *num_tables, uint32 *num_pages)
{
	//TODO: [PROJECT MS2 - BONUS] [CHUNK OPERATIONS] calculate_allocated_space
	// Write your code here, remove the panic and write your code
	//panic("calculate_allocated_space() is not implemented yet...!!");
	sva=ROUNDDOWN(sva,PAGE_SIZE);
	eva=ROUNDUP(eva,PAGE_SIZE);
	struct FrameInfo* ptr=NULL;
	uint32 *ptr_page_table = NULL;
	uint32 *second_ptr=NULL;
	uint32 *glopal_ptr=NULL;
	for(uint32 i=sva;i<eva;i+=PAGE_SIZE)
	{
		get_page_table(page_directory, i, &second_ptr);
	    if((second_ptr!=glopal_ptr && second_ptr!=NULL))
	    {
	    	(*num_tables)++;
	    }
		 glopal_ptr=second_ptr;
	}
	for(uint32 i=sva;i<eva;i+=PAGE_SIZE)
	{
		ptr=get_frame_info(page_directory,i,&ptr_page_table);
		if (ptr != NULL)
		{
			(*num_pages)++;
		}
	}
}

/*BONUS*/
//=====================================
// 6) CALCULATE REQUIRED FRAMES IN RAM:
//=====================================
// calculate_required_frames:
// calculates the new allocation size required for given address+size,
// we are not interested in knowing if pages or tables actually exist in memory or the page file,
// we are interested in knowing whether they are allocated or not.
uint32 calculate_required_frames(uint32* page_directory, uint32 sva, uint32 size)
{
	//TODO: [PROJECT MS2 - BONUS] [CHUNK OPERATIONS] calculate_required_frames
	// Write your code here, remove the panic and write your code
	//panic("calculate_required_frames() is not implemented yet...!!");

	uint32 svm = ROUNDDOWN(sva,PAGE_SIZE);
	uint32 eva = sva+size;
	eva = ROUNDUP(eva,PAGE_SIZE);
	uint32 num_pages = 0;
	uint32 num_tables = 0;
	uint32 h = 0;
	uint32 glopal_ptr = svm;
	uint32 *ptr_page_table = NULL;
	struct FrameInfo* ptr = NULL;

	for(uint32 i = svm; i < eva; i+=PAGE_SIZE)
	{
		ptr = get_frame_info(page_directory, i, &ptr_page_table);
		if(ptr == NULL)
		{
			num_pages++;
		}
	}

	int ret1 = get_page_table(page_directory, glopal_ptr, &ptr_page_table);
	if (ret1 == TABLE_NOT_EXIST)
	{
		num_tables++;
	}

	for(uint32 i = svm; i < eva; i+=PAGE_SIZE)
	{
		int ret = get_page_table(page_directory, i, &ptr_page_table);
		if(ret==TABLE_NOT_EXIST && PDX(i)!=PDX(glopal_ptr))
		{
			num_tables++;
		}
		glopal_ptr=i;
	}

	return (num_pages+num_tables);
}

//=================================================================================//
//===========================END RAM CHUNKS MANIPULATION ==========================//
//=================================================================================//

/*******************************/
/*[2] USER CHUNKS MANIPULATION */
/*******************************/

//======================================================
/// functions used for USER HEAP (malloc, free, ...)
//======================================================

//=====================================
// 1) ALLOCATE USER MEMORY:
//=====================================
void allocate_user_mem(struct Env* e, uint32 virtual_address, uint32 size)
{
	// Write your code here, remove the panic and write your code
	//panic("allocate_user_mem() is not implemented yet...!!");
}

//=====================================
// 2) FREE USER MEMORY:
//=====================================
void free_user_mem(struct Env* e, uint32 virtual_address, uint32 size)
{

	//TODO: [PROJECT MS3] [USER HEAP - KERNEL SIDE] free_user_mem
	// Write your code here, remove the panic and write your code
	//panic("free_user_mem() is not implemented yet...!!");

	virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
//	cprintf ("va at user kernel side = %x \n", virtual_address);
	size = ROUNDUP(size, PAGE_SIZE);
	uint32 *ptr_page_table = NULL;
	int flag = 0;

//	for(uint32 i = virtual_address; i < virtual_address + size; i+=PAGE_SIZE)
//	{
//		pf_remove_env_page(e, i);

//		unmap_frame(e->env_page_directory, i);
//		env_page_ws_invalidate(e, i);
//	}

//	int pg=0;
	for(int j = 0; j < e->page_WS_max_size; j++)
	{
		uint32 va = env_page_ws_get_virtual_address(e, j);
		uint32 ret = env_page_ws_is_entry_empty(e, j);
		if (ret == 0)
		{
//			cprintf("vaaaaaaaaaaa %x \n", va);
			if(va >= virtual_address && va < virtual_address + size)
			{
//				cprintf ("all virtual adresses = %x \n", va);
				e->page_last_WS_index = j;
				unmap_frame(e->env_page_directory, va);
				env_page_ws_clear_entry(e, j);
//				pg++;
			}
		}
	}

//	int pg_tb=0;
	for(uint32 i = virtual_address; i < virtual_address + size; i+=4096)
	{
		pf_remove_env_page(e, i);

		int ret = get_page_table(e->env_page_directory, i, &ptr_page_table);
		if(ret == TABLE_IN_MEMORY)
		{
			for(int j = 0; j < 1024; j++)
			{
				if(ptr_page_table[j] != 0)
				{
					flag = 1;
					break;
				}
			}
			if(flag == 0)
			{
				kfree((void *)ptr_page_table);
				e->env_page_directory[PDX(i)] = 0;
//				pg_tb++;
			}
		}
		flag = 0;
	}
//	cprintf ("pagesfreed = %x \n", pg);
//	cprintf ("tablesfreed = %x \n",pg_tb);

	//This function should:
	//1. Free ALL pages of the given range from the Page File
	//2. Free ONLY pages that are resident in the working set from the memory
	//3. Removes ONLY the empty page tables (i.e. not used) (no pages are mapped in the table)
}

//=====================================
// 2) FREE USER MEMORY (BUFFERING):
//=====================================
void __free_user_mem_with_buffering(struct Env* e, uint32 virtual_address, uint32 size)
{
	// your code is here, remove the panic and write your code
	panic("__free_user_mem_with_buffering() is not implemented yet...!!");

	//This function should:
	//1. Free ALL pages of the given range from the Page File
	//2. Free ONLY pages that are resident in the working set from the memory
	//3. Free any BUFFERED pages in the given range
	//4. Removes ONLY the empty page tables (i.e. not used) (no pages are mapped in the table)
}

//=====================================
// 3) MOVE USER MEMORY:
//=====================================
void move_user_mem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - KERNEL SIDE] move_user_mem
	//your code is here, remove the panic and write your code
	panic("move_user_mem() is not implemented yet...!!");

	// This function should move all pages from "src_virtual_address" to "dst_virtual_address"
	// with the given size
	// After finished, the src_virtual_address must no longer be accessed/exist in either page file
	// or main memory

	/**/
}

//=================================================================================//
//========================== END USER CHUNKS MANIPULATION =========================//
//=================================================================================//

