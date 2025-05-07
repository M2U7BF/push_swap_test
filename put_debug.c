/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   put_debug.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kkamei <kkamei@student.42tokyo.jp>         +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/05/07 16:57:06 by kkamei            #+#    #+#             */
/*   Updated: 2025/05/07 17:00:34 by kkamei           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "debug.h"

void	put_strarr(char **str)
{
	int	i;

	if (str == NULL)
		return ;
	i = 0;
	while (str[i])
	{
		printf("[%d] %s,\n", i, str[i]);
		i++;
	}
}

void	put_stack(t_dc_list *st)
{
	int		i;
	t_node	*node;

	i = 0;
	node = get_node(st, 0);
	printf("size: %d\n", st->size);
	while (node != st->dummy)
	{
		printf("[%d] pre: %d, num: %d, nex: %d\n", i, node->pre->num, node->num,
			node->next->num);
		node = node->next;
		i++;
	}
}
