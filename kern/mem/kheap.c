#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include "memory_manager.h"

//==================================================================//
//==================================================================//
//NOTE: All kernel heap allocations are multiples of PAGE_SIZE (4KB)//
//==================================================================//
//==================================================================//


void initialize_dyn_block_system()
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
//	kpanic_into_prompt("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
	LIST_INIT(&FreeMemBlocksList);
#if STATIC_MEMBLOCK_ALLOC
//DO NOTHING

#else

	MAX_MEM_BLOCK_CNT = NUM_OF_KHEAP_PAGES;
	MemBlockNodes = (void*)KERNEL_HEAP_START;
	int size_of_block = sizeof(struct MemBlock);
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
	allocate_chunk(ptr_page_directory, KERNEL_HEAP_START, size_all_struct, PERM_WRITEABLE);

#endif
//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
//[4] Insert a new MemBlock with the remaining heap size into the FreeMemBlocksList

	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
	struct MemBlock* ourBlock = LIST_LAST(&AvailableMemBlocksList);
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
	ourBlock->size = (KERNEL_HEAP_MAX-KERNEL_HEAP_START) - size_all_struct;
	ourBlock->sva = KERNEL_HEAP_MAX - ourBlock->size;
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
}

void* kmalloc(unsigned int size)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kmalloc
	// your code is here, remove the panic and write your code
//	kpanic_into_prompt("kmalloc() is not implemented yet...!!");

	//NOTE: All kernel heap allocations are multiples of PAGE_SIZE (4KB)WS
	//refer to the project presentation and documentation for details
	// use "isKHeapPlacementStrategyFIRSTFIT() ..." functions to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);

	if(isKHeapPlacementStrategyFIRSTFIT())
	{
		struct MemBlock * v1 = alloc_block_FF(size);
		if(v1 != NULL )
		{
			insert_sorted_allocList(v1);
			uint32 ali = v1->sva;
			int amira = allocate_chunk(ptr_page_directory, ali, size, PERM_WRITEABLE);
			if(amira == 0)
			{
				return (void *)ali;
			}
		}
	}

	if(isKHeapPlacementStrategyBESTFIT())
	{
		struct MemBlock *v2 = alloc_block_BF(size);
		if(v2 != NULL )
		{
			insert_sorted_allocList(v2);
			uint32 ali2 = v2->sva;
			int amira = allocate_chunk(ptr_page_directory, ali2, size, PERM_WRITEABLE);
			if(amira == 0)
			{
				return (void *)ali2;
			}
		}
	}
	return NULL;
}

void kfree(void* virtual_address)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kfree
	// Write your code here, remove the panic and write your code
//	panic("kfree() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
	virtualAddress = ROUNDDOWN(virtualAddress, 4096);
	struct MemBlock * v1 = find_block(&AllocMemBlocksList, virtualAddress);
	if(v1 != NULL)
	{
		LIST_REMOVE(&AllocMemBlocksList, v1);
		uint32 eva = (virtualAddress + v1->size);
		for(uint32 i = virtualAddress; i < eva; i+=PAGE_SIZE)
		{
			unmap_frame(ptr_page_directory, i);
		}
		insert_sorted_with_merge_freeList(v1);
	}
}

unsigned int kheap_virtual_address(unsigned int physical_address)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kheap_virtual_address
	// Write your code here, remove the panic and write your code
//	panic("kheap_virtual_address() is not implemented yet...!!");

	struct FrameInfo *elPointerDaBta3i = NULL;
	elPointerDaBta3i = to_frame_info(physical_address);
	uint32 theVirtualAddressOfThePhysicalAddress = elPointerDaBta3i->va;
	return theVirtualAddressOfThePhysicalAddress;

	//return the virtual address corresponding to given physical_address
	//refer to the project presentation and documentation for details
	//EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED ==================
}

unsigned int kheap_physical_address(unsigned int virtual_address)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kheap_physical_address
	// Write your code here, remove the panic and write your code
//	panic("kheap_physical_address() is not implemented yet...!!");

	unsigned int mashy = virtual_to_physical(ptr_page_directory, virtual_address);
	return mashy;

	//return the physical address corresponding to given virtual_address
	//refer to the project presentation and documentation for details
}


void kfreeall()
{
	panic("Not implemented!");

}

void kshrink(uint32 newSize)
{
	panic("Not implemented!");
}

void kexpand(uint32 newSize)
{
	panic("Not implemented!");
}




//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// krealloc():

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to kmalloc().
//	A call with new_size = zero is equivalent to kfree().

void *krealloc(void *virtual_address, uint32 new_size)
{
	//TODO: [PROJECT MS2 - BONUS] [KERNEL HEAP] krealloc
	// Write your code here, remove the panic and write your code
	panic("krealloc() is not implemented yet...!!");
}
