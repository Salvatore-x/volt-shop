import Shop from '@/components/shop';export default async function Page({params}:{params:Promise<{id:string}>}){const {id}=await params;return <Shop view="product" productId={id}/>}
